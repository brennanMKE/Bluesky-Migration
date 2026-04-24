# Progress

> **New session? Read this file first, then check the active item's section in `Migrate-ReactNative-to-SwiftUI.md` for the detailed checklist.**

---

## Reference Baseline — Bluesky-ReactNative

The migration targets this commit of the React Native app. When the RN repo advances, review the diff against this commit and update the relevant checklists and planning docs before continuing.

| | |
|---|---|
| **Commit** | `a90bb66d67db47e61f015c6204f9b5fd42e43efd` |
| **Date** | 2026-04-24 |
| **Message** | Nightly source-language update |
| **Last reviewed** | 2026-04-24 |

To check for drift:
```
git -C ../Bluesky-ReactNative log a90bb66d67db47e61f015c6204f9b5fd42e43efd..HEAD --oneline
```

When you review a new RN commit and confirm nothing affects the migration plan, update **Commit**, **Date**, **Message**, and **Last reviewed** above.

---

## Current Status

| | |
|---|---|
| **Phase** | 0 — Foundation |
| **Active module** | Module 1 — Auth & Session |
| **Active item** | Module 1 Gate (needs app target) |
| **Blockers** | None |

---

## Up Next

These are the first items to work on in order. Cross them off here and tick the checkbox in `Migrate-ReactNative-to-SwiftUI.md` when each is done.

### Phase 0 — Foundation

**Module 1 — Auth & Session**
- [x] `Account` struct in `BlueskyCore`: DID, handle, email, service URL, PDS URL
- [x] `SessionManaging` protocol in `BlueskyKit`
- [x] Keychain wrapper in `BlueskyDataStore` for access JWT + refresh JWT per DID
- [x] `SessionManager` (`@Observable`) in `BlueskyAuth`: login, resumeSession, logout, switchAccount, removeAccount
- [x] Login screen: handle/email + password form, service URL field
- [x] 2FA screen: TOTP token prompt on `AuthFactorTokenRequired` (inline in LoginView)
- [x] Account picker: list saved accounts, switch or remove
- [x] Session restore on app launch (`restoreLastSession()` in SessionManager)
- [x] Multi-account: store all accounts in Keychain, one `currentAccount` active
- [x] Logout: clear tokens (push unregistration deferred to Module 10)
- [ ] **Gate:** Login → kill app → relaunch → session restored ← needs app target (Module 5)

**Module 2 — Networking** _(starts after Module 1 gate passes)_
- [ ] Add `BlueskyNetworking` target to `BlueskyKit/Package.swift`
- [x] `NetworkClient` protocol in `BlueskyKit`
- [ ] `ATProtoClient` with `URLSession` + bearer auth header
- [ ] Auto-refresh: intercept 401, use refresh token, retry original request
- [x] Error types in `BlueskyCore`: `ATError` (network, auth, XRPC lexicon errors)
- [x] Cursor pagination type in `BlueskyCore`: `PagedResult<T>`
- [ ] Codable lexicon types for all endpoint groups — feed, actor, notification, graph, repo, chat, moderation
  - [x] `app.bsky.feed.*` core types: `PostRecord`, `PostView`, `FeedViewPost`, embed hierarchy, `RichTextFacet`
  - [x] `app.bsky.actor.*` core types: `ProfileBasic`, `ProfileView`, `ProfileDetailed`, `Label`
  - [ ] `app.bsky.notification.*`
  - [ ] `app.bsky.graph.*` (followers, follows, mutes, blocks, lists)
  - [ ] `com.atproto.repo.*` (applyWrites, uploadBlob)
  - [ ] `app.bsky.chat.*` (DM convos, messages, send)
  - [ ] Moderation lexicons (labeler, report)
- [ ] **Gate:** Unit test each endpoint group against `public.api.bsky.app`

**Module 3 — DataStore** _(starts after Module 2 gate passes)_
- [ ] Storage protocols in `BlueskyKit`: `AccountStore`, `PreferencesStore`, `CacheStore`
  - [x] `AccountStore` protocol (with `nonisolated` requirements)
  - [x] `PreferencesStore` protocol (with `nonisolated` requirements)
  - [ ] `CacheStore` protocol
- [ ] `KeychainAccountStore`
- [ ] `UserDefaultsPreferencesStore`
- [ ] `SwiftDataCacheStore`
- [ ] App group container setup
- [ ] **Gate:** Preferences survive restart; cache serves stale while fresh fetch loads

---

## Completion Log

_Append entries here as items are finished. Most recent at the top._

| Date | Module | Item |
|------|--------|------|
| 2026-04-24 | BlueskyAuth | `AccountPickerView`: account list with avatar, switch, remove (context menu) |
| 2026-04-24 | BlueskyAuth | `LoginView`: handle/password form, custom PDS URL, 2FA inline, iOS keyboard/content-type annotations |
| 2026-04-24 | BlueskyAuth | `SessionManager` (`@MainActor @Observable`): login, resumeSession, switchAccount, logout, removeAccount, restoreLastSession; JWT expiry check; direct URLSession for auth endpoints |
| 2026-04-24 | BlueskyCore | `ATError.authFactorTokenRequired` case for 2FA TOTP flow |
| 2026-04-24 | BlueskyDataStore | `KeychainAccountStore` actor: save/load/remove/setCurrentDID per DID, `kSecAttrAccessibleAfterFirstUnlock`; `KeychainError` |
| 2026-04-24 | BlueskyKit | `nonisolated` on `AccountStore`, `PreferencesStore`, `NetworkClient` requirements; `SessionManaging` correctly left `@MainActor` |
| 2026-04-24 | BlueskyCore | `Embed`, `EmbedView` indirect enums with `$type` Codable discrimination; `BlobRef` IPLD link Codable |
| 2026-04-23 | BlueskyCore | `PostRecord`, `PostView`, `FeedViewPost`, `ReplyRef`, `FeedReason` (Post.swift) |
| 2026-04-23 | BlueskyCore | `RichTextFacet`, `ByteSlice`, `FacetFeature` with `$type` Codable (RichText.swift) |
| 2026-04-23 | BlueskyCore | `ProfileBasic`, `ProfileView`, `ProfileDetailed`, `Label`, `ListBasic`, `ProfileViewerState` (Profile.swift) |
| 2026-04-23 | BlueskyCore | `Account`, `StoredAccount` (Account.swift) |
| 2026-04-23 | BlueskyCore | `ATError` (ATError.swift) |
| 2026-04-23 | BlueskyCore | `Cursor`, `PagedResult<T>` (Pagination.swift) |
| 2026-04-23 | BlueskyCore | `DID`, `Handle`, `ATURI`, `CID` (Identifiers.swift) |
| 2026-04-23 | BlueskyKit | `BlueskyEnvironment` DI container (Bootstrap.swift) |
| 2026-04-23 | BlueskyKit | `NetworkClient` protocol |
| 2026-04-23 | BlueskyKit | `PreferencesStore` protocol |
| 2026-04-23 | BlueskyKit | `AccountStore` protocol |
| 2026-04-23 | BlueskyKit | `SessionManaging` protocol |
| 2026-04-23 | Package.swift | `BlueskyKit` → `BlueskyCore` dependency; `BlueskyKitTests` → both |

---

## Decisions Made

_Record any deferred decisions from `Strategy.md` once resolved._

| Decision | Resolution | Date |
|----------|-----------|------|
| `BlueskyCore` actor isolation | **None** — BlueskyCore has no `defaultIsolation` setting. Data types must be decodable from any context (networking tasks). All other modules keep `defaultIsolation(MainActor.self)`. | 2026-04-23 |
| `SessionManaging` isolation | **`@MainActor`** — `currentAccount` and `accounts` are UI state observed by SwiftUI. Implementation will be a `@MainActor @Observable` class. Async methods dispatch network work internally via `await`-ing a `nonisolated NetworkClient`. | 2026-04-24 |
| `AccountStore` / `PreferencesStore` / `NetworkClient` isolation | **`nonisolated` requirements** — These are I/O-bound protocols. Their requirements are marked `nonisolated` so implementations can be actor-isolated (e.g. a Keychain actor) without inheriting `@MainActor`. | 2026-04-24 |
| Cache store backend | — | — |
| Networking library | URLSession (see Strategy.md recommendation) | — |
| TestFlight beta tracks | — | — |
| App group identifier | — | — |
| Video playback library | AVPlayer (see Strategy.md) | — |

---

## Session Notes

**2026-04-24 — Foundation complete; concurrency model settled**

All `BlueskyCore` types and `BlueskyKit` protocols are in place. The `swift test` suite passes with 9 tests. Key pattern to remember for all future modules:

- `BlueskyCore` types are plain Swift value types — no `@MainActor`, no `nonisolated`. They just work from any context.
- Protocol requirements in `BlueskyKit` that are I/O-bound (AccountStore, PreferencesStore, NetworkClient) carry `nonisolated` so their implementations can be actors.
- Protocol requirements in `BlueskyKit` that carry UI state (SessionManaging) are `@MainActor` by default from the module isolation setting — leave them that way.
- Test mocks for `@MainActor` protocols → `@MainActor final class`. Test mocks for `nonisolated` protocols → `final class, @unchecked Sendable` (test target has no default isolation, so methods are nonisolated by default).
- `Embed` and `EmbedView` are `indirect enum` because `recordWithMedia` nests the same type recursively.

**Next session:** Start with `KeychainAccountStore` in `BlueskyDataStore`. The `AccountStore` protocol is ready; the Keychain wrapper is the first concrete I/O implementation.

---

**2026-04-24 — Module 1 code complete; gate pending app target**

All Module 1 implementation items are done:
- `KeychainAccountStore` actor in `BlueskyDataStore` — stores JWTs per DID with `kSecAttrAccessibleAfterFirstUnlock`
- `SessionManager` (`@MainActor @Observable`) in `BlueskyAuth` — login, resumeSession (with JWT expiry + refresh), switchAccount, logout, removeAccount, restoreLastSession
- `LoginView` in `BlueskyAuth` — handle/password/service-URL form; 2FA field appears inline on `authFactorTokenRequired`
- `AccountPickerView` in `BlueskyAuth` — account list with avatar, switch, remove

Key patterns learned this session:
- `BlueskyAuth` has `defaultIsolation(MainActor.self)` like all non-Core modules. Private `Decodable` struct conformances become `@MainActor`-isolated. Avoid `T: Decodable & Sendable` generic constraints from `@MainActor` methods — use `T: Decodable` only (both sides are on the main actor).
- Auth endpoints (createSession, refreshSession, deleteSession) need special bearer tokens (none / refreshJwt), so `SessionManager` calls URLSession directly for these rather than going through `NetworkClient`.
- `actor` with `nonisolated func` wrappers that `await` internal actor-isolated helpers: the cleanest pattern for an I/O type satisfying `nonisolated` protocol requirements.
- For SwiftUI `#if os(iOS)` guards in ViewBuilder closures, apply per-modifier rather than wrapping the whole view.

**Module 1 Gate** requires the `Bluesky-SwiftUI` app target (Module 5). The gate check — login → kill → relaunch → session restored — cannot be validated in SPM alone. Start Module 2 (Networking) now; return to the gate when the app shell exists.

**Next session:** Start `BlueskyNetworking` — add the target to `Package.swift`, implement `ATProtoClient` with `URLSession` + bearer auth + 401 auto-refresh.

---

## How to Update This File

- **Starting an item:** set it as the Active item above.
- **Finishing an item:** tick its checkbox here, tick it in `Migrate-ReactNative-to-SwiftUI.md`, and add a row to the Completion Log.
- **Finishing a module gate:** update Current Status to the next module.
- **Finishing a phase:** update Current Status to the next phase and add the next phase's items to "Up Next".
- **Resolving a deferred decision:** fill in the Decisions Made table and remove it from `Strategy.md`'s Deferred Decisions section.
