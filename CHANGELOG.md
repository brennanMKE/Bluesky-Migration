# Changelog

All completed work, most recent first. Mirrors the Completion Log in `Progress.md`.

---

## 2026-04-24 — Module 2: Networking complete (gate pending)

### BlueskyNetworking (new module)
- `ATProtoClient` actor — URLSession-based `NetworkClient` implementation; bearer auth on every request; 401 intercept → `refreshSession` → retry; updated tokens saved back to `AccountStore`

### BlueskyCore — lexicon types
- `Notification.swift` — `NotificationView`, `ListNotificationsResponse`, `UpdateSeenRequest`, `RegisterPushRequest` (`app.bsky.notification.*`)
- `Graph.swift` — `GetFollowersResponse`, `GetFollowsResponse`, `GetMutesResponse`, `GetBlocksResponse`, `GetListsResponse`, `ListView` (`app.bsky.graph.*`)
- `Repo.swift` — `UploadBlobResponse`, `WriteCreate`, `WriteDelete`, `WriteOp`, `ApplyWritesRequest/Response`, `RepoCommit`, `AnyEncodable` (`com.atproto.repo.*`)
- `Chat.swift` — `ConvoView`, `MessageView`, `MessageSender`, `MessageInput`, `SendMessageRequest`, `ListConvosResponse`, `GetMessagesResponse` (`chat.bsky.*`)
- `Moderation.swift` — `ReportSubjectRepo`, `ReportSubjectRecord`, `CreateReportRequest/Response`, `LabelerView`

### Package.swift
- `BlueskyNetworking` target added; no `defaultIsolation` (ATProtoClient is a custom actor)

### Tests
- 24 tests pass — Codable round-trips and encoding checks for all new lexicon types

---

## 2026-04-24

### BlueskyAuth (new module)
- `SessionManager` (`@MainActor @Observable`) — login, `resumeSession` (JWT expiry check + refresh), `switchAccount`, `logout`, `removeAccount`, `restoreLastSession`; calls `URLSession` directly for auth endpoints (createSession, refreshSession, deleteSession) rather than going through `NetworkClient` to handle non-standard bearer token requirements
- `LoginView` — handle/password/service-URL form; 2FA token field appears inline on `authFactorTokenRequired`; iOS keyboard type and content-type annotations; `#if os(iOS)` guards applied per-modifier

- `AccountPickerView` — account list with avatar, switch active account, remove account (context menu)

### BlueskyDataStore (new module)
- `KeychainAccountStore` actor — save/load/remove/setCurrentDID per DID; `kSecAttrAccessibleAfterFirstUnlock` accessibility; `KeychainError` type

### BlueskyCore
- `ATError.authFactorTokenRequired` case added for TOTP 2FA flow
- `Embed` and `EmbedView` — `indirect enum` (required for `recordWithMedia` nesting same type recursively); `$type` Codable discrimination; `BlobRef` IPLD link Codable

### BlueskyKit
- `nonisolated` keyword added to `AccountStore`, `PreferencesStore`, and `NetworkClient` protocol requirements — allows actor-isolated implementations to satisfy these protocols without inheriting `@MainActor`
- `SessionManaging` requirements left `@MainActor` (correct — `currentAccount` and `accounts` are observed UI state)

### Architecture decision — concurrency model settled
- `BlueskyCore` carries no actor isolation; data types must decode from networking contexts
- I/O-bound protocol requirements (`AccountStore`, `PreferencesStore`, `NetworkClient`) use `nonisolated` so implementations can be actors
- UI-state protocol requirements (`SessionManaging`) remain `@MainActor`
- Test mocks for `@MainActor` protocols: `@MainActor final class`; test mocks for `nonisolated` protocols: `final class, @unchecked Sendable`

---

## 2026-04-23

### BlueskyCore (new module)
- `DID`, `Handle`, `ATURI`, `CID` — AT Protocol identifier value types (`Identifiers.swift`)
- `ATError` — network, auth, and XRPC lexicon error cases (`ATError.swift`)
- `Cursor`, `PagedResult<T>` — cursor-based pagination envelope (`Pagination.swift`)
- `Account`, `StoredAccount` — account model with DID, handle, email, service URL, PDS URL (`Account.swift`)
- `ProfileBasic`, `ProfileView`, `ProfileDetailed`, `Label`, `ListBasic`, `ProfileViewerState` (`Profile.swift`)
- `RichTextFacet`, `ByteSlice`, `FacetFeature` — `$type` Codable discrimination for mention/hashtag/URL facets (`RichText.swift`)
- `PostRecord`, `PostView`, `FeedViewPost`, `ReplyRef`, `FeedReason` — core feed types (`Post.swift`)

### BlueskyKit (new module)
- `SessionManaging` protocol
- `AccountStore` protocol
- `PreferencesStore` protocol
- `NetworkClient` protocol
- `BlueskyEnvironment` DI container and `makeEnvironment()` bootstrap factory (`Bootstrap.swift`)

### Package.swift
- `BlueskyKit` → `BlueskyCore` dependency wired
- `BlueskyKitTests` target depends on both `BlueskyKit` and `BlueskyCore`
- `swift test` passes (9 tests)

---

## 2026-04-23 — Project setup

- `Strategy.md` — 4-phase migration plan with milestone definitions, working rhythm, risk register, deferred decisions, and success criteria
- `Progress.md` — session-continuity tracking file (current status, up-next checklist, completion log, decisions made, session notes)
- `README.md` — project overview, repository layout, tech stack, phase summary
