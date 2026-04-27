# Modular Architecture — BlueskyKit

## Principles

1. **Stable public API, hidden implementation.** Every module exposes only what callers need — protocols, model types, and result types are public. Concrete implementations (SwiftData classes, URLSession calls, Keychain queries) are internal. A caller never knows or cares which storage engine is running underneath.

2. **Protocol-first.** Each service is defined as a Swift protocol. The Xcode app target (or a test target) injects a concrete implementation. This makes modules independently testable with mocks and makes implementations swappable without touching callers.

3. **One Swift package, many library targets.** All modules live in a single `Package.swift` in `BlueskyKit`. Each module is a `.library` product. The app's Xcode target lists only the top-level modules it needs as dependencies; transitive dependencies are resolved by SPM.

4. **Strict layering.** A lower-level module never imports a higher-level one. The dependency graph is a DAG with no cycles. See the graph below.

5. **Versioned modules.** Each module has a `moduleVersion` constant in its public interface. When a module's public API changes in a breaking way, the version increments and callers are updated explicitly. Eventually, alternative implementations of a module (e.g. a SQLite-backed DataStore alongside a SwiftData-backed one) can coexist as separate targets behind the same protocol.

---

## Dependency Graph

```
Layer 0 — BlueskyCore (shared models, no dependencies)

Layer 1 — BlueskyKit (protocols + bootstrap, depends on BlueskyCore)

Layer 2 — Implementations (each depends on BlueskyKit + BlueskyCore)
  BlueskyAuth    BlueskyDataStore    BlueskyUI    BlueskyNetworking

Layer 3 — Feature modules (depend on Layer 2 as needed)
  BlueskyFeed    BlueskyProfile    BlueskyNotifications
  BlueskyMessages    BlueskySearch    BlueskyComposer
  BlueskyModeration    BlueskySettings    BlueskyLists
```

Arrow direction = "depends on". Higher layers may depend on any lower layer, never the reverse.

---

## Package Structure

See `../BlueskyKit/README.md` for the authoritative module descriptions. The current targets in `BlueskyKit/Package.swift`:

```
BlueskyKit/
├── Package.swift
├── Sources/
│   ├── BlueskyCore/         ← Layer 0: shared data types (structs, enums, value types)
│   │   └── BlueskyCore.swift
│   │
│   ├── BlueskyKit/          ← Layer 1: public API protocols + bootstrap logic
│   │   └── BlueskyKit.swift
│   │
│   ├── BlueskyAuth/         ← Layer 2: authentication implementation
│   │   └── BlueskyAuth.swift
│   │
│   ├── BlueskyDataStore/    ← Layer 2: persistence implementation
│   │   └── BlueskyDataStore.swift
│   │
│   └── BlueskyUI/           ← Layer 2: SwiftUI views and components
│       └── BlueskyUI.swift
│
└── Tests/
    └── BlueskyKitTests/
```

See `ProjectStructure.md` for the process of adding new modules to `Package.swift`.

---

## What Goes Where

| Layer | Module | Contents |
|-------|--------|----------|
| 0 | `BlueskyCore` | Value types shared across all modules: `Post`, `Profile`, `FeedItem`, `Notification`, `Conversation`, `RichText` facets, XRPC envelope types, `ATError`, cursor/pagination types |
| 1 | `BlueskyKit` | Public protocols for all subsystems (`SessionManaging`, `DataStoring`, `NetworkClient`, etc.) + factory bootstrap functions |
| 2 | `BlueskyAuth` | `SessionManager` implementation, `Account` model, `LoginView`, `AccountPickerView` |
| 2 | `BlueskyDataStore` | Keychain account store, UserDefaults preferences, SwiftData/SQLite cache |
| 2 | `BlueskyUI` | Design system: themes, spacing tokens, typography; shared components: `PostCard`, `AvatarView`, `RichTextView`, `EmbedView` |
| 2 | `BlueskyNetworking` | `URLSession`-based XRPC client, token refresh interceptor, lexicon request/response types |
| 3 | Feature modules | ViewModels, Feature Stores, SwiftUI screens; one module per feature area |
| 3 | Feature Stores | `@Observable` classes that own canonical data, call `NetworkClient`, and read/write `CacheStore`. One or more per feature module. |

---

## Protocol-First Pattern (Example: DataStore)

```swift
// BlueskyKit — public protocols (Layer 1)

public protocol AccountStore: Sendable {
    func save(_ account: StoredAccount) throws
    func loadAll() throws -> [StoredAccount]
    func remove(did: String) throws
    func setCurrentDID(_ did: String?) throws
    func loadCurrentDID() throws -> String?
}

public protocol PreferencesStore: Sendable {
    func set<T: Codable>(_ value: T, for key: PreferenceKey) throws
    func get<T: Codable>(_ type: T.Type, for key: PreferenceKey) -> T?
}

public protocol CacheStore: Sendable {
    func save<T: Codable>(_ value: T, forKey key: String) throws
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T?
    func clear(forKey key: String) throws
    func clearAll() throws
}
```

`BlueskyDataStore` provides concrete implementations (`KeychainAccountStore`, `UserDefaultsPreferencesStore`, `SwiftDataCacheStore`) and factory functions. Callers hold `any AccountStore`. Swapping to a SQLite backend means changing the factory — nothing else.

---

## Protocol-First Pattern (Example: Auth)

```swift
// BlueskyKit — public protocol (Layer 1)

public protocol SessionManaging: AnyObject, Observable, Sendable {
    var currentAccount: Account? { get }
    var accounts: [Account] { get }

    func login(identifier: String, password: String, service: URL) async throws
    func login(identifier: String, password: String, service: URL, twoFactorToken: String) async throws
    func resumeSession() async throws
    func switchAccount(did: String) async throws
    func logout() async throws
    func removeAccount(did: String) async throws
}
```

`BlueskyAuth` provides the concrete `SessionManager`. The app's `RootView` receives `any SessionManaging` via the SwiftUI environment. Tests inject a `MockSessionManager`.

---

## Protocol-First Pattern (Example: Feature Store)

```swift
// BlueskyKit — public protocol (Layer 1)

public protocol FeedStoring: AnyObject, Observable {
    var posts: [FeedViewPost] { get }
    var isLoading: Bool { get }

    func load(selection: FeedSelection, reset: Bool) async
    func like(post: PostView) async
    func unlike(post: PostView) async
    func repost(post: PostView) async
    func unrepost(post: PostView) async
}
```

`BlueskyFeed` provides the concrete `FeedStore`. `FeedViewModel` holds `any FeedStoring` and
derives its displayed data via computed properties — it contains no `NetworkClient` reference.
Tests inject a `MockFeedStore`.

The store pattern applies to every feature module:
`FeedStore`, `ThreadStore`, `BookmarksStore`, `ProfileStore`, `SearchStore`,
`NotificationsStore`, `ConversationStore`, `ModerationStore`, `ListsStore`, `SettingsStore`.

---

## Dependency Injection

Dependencies flow downward through initializers and the SwiftUI environment — no global singletons, no service locator.

```swift
// App entry point (Bluesky-SwiftUI) wires everything up
@main
struct BlueskyApp: App {
    private let accountStore = makeAccountStore()
    private let cache        = makeCacheStore()
    private let networking   = makeNetworkingClient()
    private let session      = makeSessionManager(
        networking: networking,
        accountStore: accountStore
    )
    private let feedStore    = FeedStore(network: networking, cache: cache)
    // … one store per feature module

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(session)
                .environment(feedStore)
                // … inject remaining stores
        }
    }
}
```

Feature modules receive dependencies through their own initializers — they never call factory functions directly.

---

## Versioning & Alternative Implementations

Each module declares a public constant:

```swift
// BlueskyKit (Layer 1)
public let moduleVersion = 1
```

When the public API changes incompatibly, increment and update all callers in the same PR.

Alternative implementations are additional targets in `Package.swift`:

```swift
// Package.swift (future example)
.target(
    name: "BlueskySQLiteDataStore",     // alternative to BlueskyDataStore
    dependencies: ["BlueskyKit", "BlueskyCore", .product(name: "SQLite", package: "swift-sqlite")]
),
```

The app selects which factory to call at the composition root. Everything else is unchanged.

---

## Testing Strategy

| Module | Test approach |
|--------|--------------|
| `BlueskyCore` | Pure unit tests — encode/decode fixture JSON, no I/O |
| `BlueskyKit` | Compile-time: verify mock conformances; no runtime tests needed |
| `BlueskyNetworking` | Integration tests against `public.api.bsky.app` (unauthenticated endpoints) |
| `BlueskyDataStore` | Unit tests using in-memory mocks (`InMemoryAccountStore`, etc.) |
| `BlueskyAuth` | Unit tests with `MockNetworking` + `MockAccountStore` |
| Feature Stores | Unit tests with `MockNetworkClient` + `MockCacheStore`; verify stale-while-revalidate and optimistic-update revert paths |
| Feature ViewModels | Unit tests with mock stores (e.g. `MockFeedStore`); verify view-specific state machines only |
| Feature modules | `#Preview` blocks for visual validation; integration tests with real stores against `public.api.bsky.app` |
