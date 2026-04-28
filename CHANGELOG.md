# Changelog

All completed work, most recent first. Mirrors the Completion Log in `Progress.md`.

---

## 2026-04-26 — Planning: store layer architecture + RN drift review

### Architecture — Store Layer
- Added "Architecture prerequisite — Store Layer" section to `Progress.md` (complete, all items ticked)
- Added `FeedStoring`, `ProfileStoring`, `SearchStoring`, `NotificationsStoring`, `ConversationStoring`, `ModerationStoring`, `SettingsStoring`, `ComposerStoring`, `ListsStoring`, `BookmarksStoring`, `ThreadStoring` protocol items to each respective module in `Migrate-ReactNative-to-SwiftUI.md`
- Each feature module checklist now includes: protocol in `BlueskyKit`, `@Observable` store in the feature target (reads/writes `CacheStore`), and ViewModel refactor (zero direct `network.*` calls)
- Recorded "Feature Store pattern" decision in `Progress.md` Decisions Made table
- `ModularArchitecture.md` and `Strategy.md` updated with store layer requirements and risk entry

### RN Drift — Group Clops feature branch (#10360)
- RN baseline advanced from `a90bb66` (2026-04-24) to `46b8a58` (2026-04-25)
- `chat.bsky.group.*` lexicon namespace identified as new (distinct from `chat.bsky.convo.*`): `addMembers`, `removeFromGroup`, `editGroupChatName`, `lockConversation`, plus four join-link mutations
- `ConvoWithDetails` discriminated union (group vs. direct) and updated `ConvoItem.relatedProfiles` (`[DID: ProfileBasic]` dictionary) identified as required changes to Module 11
- Module 11 group chat subtasks expanded in both `Progress.md` and `Migrate-ReactNative-to-SwiftUI.md`

---

## 2026-04-25 — Module 15: Remaining Screens complete

### BlueskyCore
- `Auth.swift` (new): `AppPasswordView`, `ListAppPasswordsResponse`, `CreateAppPasswordRequest`, `CreateAppPasswordResponse`, `RevokeAppPasswordRequest`
- `StarterPack.swift` (new): `StarterPackView`, `StarterPackBasic`, `StarterPackRecord`, `GetStarterPackResponse`, `GetActorStarterPacksResponse`
- `Bookmark.swift` (new): `BookmarkView`, `GetBookmarksResponse`, `CreateBookmarkRequest`, `DeleteBookmarkRequest` — `app.bsky.bookmark.*` lexicons
- `Graph.swift`: added `ListRecord`, `ListItemRecord`, `GetListFeedResponse`
- `Moderation.swift`: added `SavedFeed` (Codable, Identifiable); extended `GetPreferencesResponse` with `savedFeeds`; `PutPreferencesRequest.init(savedFeeds:)`; `GetLabelerServicesResponse`

### BlueskyFeed
- `VideoFeedView`: AVKit `VideoPlayer` in full-screen vertical-paging `TabView`; `#if os(iOS)` on `.tabViewStyle(.page)` and `.navigationBarTitleDisplayMode`
- `SavedFeedsScreen` + `SavedFeedsViewModel`: pinned/saved sections, drag-to-reorder, swipe-to-delete, pin toggle; saves via `app.bsky.actor.putPreferences` with `savedFeedsPrefV2`
- `BookmarksScreen` + `BookmarksViewModel`: paginated bookmark list with pull-to-refresh and swipe-to-remove; `app.bsky.bookmark.getBookmarks` / `deleteBookmark`

### BlueskyLists (new module)
- `ListsScreen` + `ListsViewModel`: paginated list of user's curated lists, swipe-to-delete, create sheet
- `ListDetailScreen` + `ListDetailViewModel`: Members / Feed segmented tabs; add/remove member
- `ListCreateSheet`: name + purpose picker (modlist/curatelist) + description form
- `StarterPackScreen`: view members, follow-all button, `app.bsky.graph.getStarterPack`
- `StarterPackCreateSheet`: name / description / list picker form
- `Package.swift`: `BlueskyLists` target added

### BlueskyModeration
- `LabelerProfileScreen` + `LabelerProfileViewModel`: subscribe/unsubscribe via saved feeds prefs; applied labels list; `app.bsky.labeler.getServices`

### BlueskySettings
- `AppPasswordsScreen` + `AppPasswordsViewModel`: list/create/revoke via `com.atproto.server.*`; shows new password in alert with clipboard copy

---

## 2026-04-25 — Module 14: Settings complete

### BlueskyCore
- `Contacts.swift` (new): `app.bsky.contact.*` lexicon types — `StartPhoneVerificationRequest`, `VerifyPhoneRequest/Response`, `ImportContactsRequest/Response`, `ContactMatchItem`, `GetContactMatchesResponse`, `ContactSyncStatus`, `GetContactSyncStatusResponse`, `DismissMatchRequest`

### BlueskySettings (new module)
- `SettingsViewModel` (`@Observable`): `UserDefaults`-backed theme, font size, content, accessibility, language, and notification toggle preferences; `load()`/`save()`/`setTheme()` helpers
- `SettingsScreen`: hub `List` with Account, Appearance, Preferences, Notifications, Privacy, About sections; Find Friends row; Moderation callback; Sign Out destructive button
- `AppearanceSettingsScreen`: segmented theme picker (light/dark/dim) + font-size Slider with live preview
- `LanguageSettingsScreen`: post language tags with add/remove
- `NotificationSettingsScreen`: per-type push notification toggles
- `ContentSettingsScreen`: autoplay video, external embeds, alt-text requirement
- `AccessibilitySettingsScreen`: reduce motion, open-links-in-app toggles
- `PrivacySettingsScreen`: placeholder directing users to bsky.app for activity privacy settings
- `AccountSettingsScreen` (private stub): directs users to bsky.app for email/password/2FA changes
- `AboutScreen`: version + build from `Bundle.main`; links to ToS, Privacy Policy, Community Guidelines
- `FindContactsScreen`: 4-step flow — phone input → OTP verify (`app.bsky.contact.verifyPhone`) → `CNContactStore` permission + upload (`app.bsky.contact.importContacts`, max 1000 numbers via `Task.detached`) → match list with optimistic follow buttons; `#if os(iOS)` guards on `keyboardType`/`textContentType`

### Package.swift
- `BlueskySettings` target added (depends on BlueskyKit, BlueskyCore, BlueskyUI)

---

## 2026-04-24 — Module 13: Moderation complete

### BlueskyCore
- `Moderation.swift` updated: `GetListResponse`, `ListItemView`, `ListMuteRequest`, `ContentLabelPref`, `GetPreferencesResponse` (custom decoder parsing polymorphic `$type` preference array to extract `adultContentPref` + `contentLabelPref` items), `PutPreferencesRequest` (private `_AdultPref`/`_LabelPref` helpers with `$type` encoding via `AnyEncodable`)

### BlueskyModeration (new module)
- `ModerationViewModel` (`@Observable`): `loadMutes`/`loadMoreMutes`, `loadBlocks`/`loadMoreBlocks`, `loadModLists`/`loadMoreModLists`, `loadPreferences`; mutations `unmute(did:)`, `unblock(profile:)`, `muteList`/`unmuteList`, `setAdultContent`, `setLabelVisibility`, `report(subject:reasonType:reason:)`; all mutations optimistic with revert on failure
- `MutesScreen` + `BlocksScreen`: paginated lists with `ContentUnavailableView` on empty; Unmute/Unblock buttons (`role: .destructive`); infinite scroll trigger on last row
- `ModerationListsScreen`: lists filtered to `app.bsky.graph.defs#modlist` purpose; Unsubscribe via `unmuteActorList`
- `ContentFilterSettingsScreen`: adult content `Toggle`-gated section; per-label `Picker(.menu)` for hide/warn/show (porn, sexual, nudity, graphic-media, hate, spam)
- `ReportDialog`: `NavigationStack` form with reason `Picker(.inline)` + optional `TextEditor`; submits via `com.atproto.moderation.createReport` with `ReportSubjectRepo` or `ReportSubjectRecord`; success `.alert` auto-dismisses; takes `ReportSubjectKind` enum at call site
- `ModerationScreen`: hub `List` with nav links to all sub-screens

### Bluesky-SwiftUI
- Profile tab toolbar gains shield button → `ModerationScreen` via `navigationDestination`

### Gate
- Module 13 Gate pending: mute/block applies immediately; labeler settings filter content (needs live API)

---

## 2026-04-24 — Module 12: Composer complete

### BlueskyKit / BlueskyNetworking
- `NetworkClient.upload(lexicon:data:mimeType:)` protocol requirement added
- `ATProtoClient.performUpload`: raw `httpBody` POST to `com.atproto.repo.uploadBlob`; `PreviewNetworkClient` + `MockNetworkClient` updated

### BlueskyComposer (new module)
- `FacetBuilder`: UTF-8 byte-accurate `#hashtag` / `@mention` facets via Swift regex + `samePosition(in: utf8)` → byte range → `RichTextFacet`
- `ComposerViewModel` (`@Observable`): image upload pipeline (blob → `UploadBlobResponse` → `EmbedImage`), embed assembly (images/record/recordWithMedia), `createRecord` call via `com.atproto.repo.createRecord`; 200ms debounced mention autocomplete via `app.bsky.actor.searchActorsTypeahead`
- `ComposerSheet`: `TextEditor` + floating mention overlay (`List` of suggestions), quote preview card, image grid (up to 4) + alt text popover, language picker, 300-character counter, `PHPickerRepresentable` wrapper for iOS image selection

### Gate
- Module 12 Gate pending: post with text, images, mention (needs live API)

---

## 2026-04-24 — Module 11: Direct Messages complete

### BlueskyMessages (new module)
- `MessagesViewModel` (`@Observable`): `loadInitial`/`loadMore`/`refresh`/`leaveConvo`/`muteConvo` via `chat.bsky.convo.listConvos`; optimistic updates with revert on failure
- `MessageThreadViewModel` (`@Observable`): `load`/`loadOlder`/`sendMessage`/`markRead` via `chat.bsky.convo.*`; `isOwn(_:)` for bubble alignment
- `ConversationListScreen`: `ConvoRow` with unread badge; swipe actions (Leave, Mute/Unmute); `navigationDestination` → `MessageThreadScreen`
- `MessageThreadScreen`: `ScrollViewReader` + `LazyVStack`; chat bubbles (own = accent/trailing, other = secondary/leading); compose bar with send button

### Gate
- Module 11 Gate pending: send/receive DMs (needs live API)

---

## 2026-04-24 — Module 10: Notifications complete

### BlueskyNotifications (new module)
- `NotificationsViewModel` (`@Observable`): `loadInitial`/`loadMore`/`refresh`/`markSeen`/`fetchUnreadCount` via `app.bsky.notification.*`; `unreadCount: Int` drives tab badge
- `NotificationsScreen`: `List` with `NotificationRow` + reason icons (like/repost/follow/mention/quote/reply); pull-to-refresh via `.refreshable`; infinite scroll on last row; `markSeen` dispatched in `.task`

### Gate
- Module 10 Gate pending: notification list updates, badge clears on open (needs live API)

---

## 2026-04-24 — Module 9: Search & Discovery complete

### BlueskyCore
- `Search.swift`: `SearchActorsResponse`, `SearchActorsTypeaheadResponse`, `GetSuggestionsResponse`, `SearchPostsResponse`, `GetSuggestedFeedsResponse`

### BlueskySearch (new module)
- `SearchViewModel` (`@Observable`): actors/posts/feeds result tabs; 300ms debounced search via `app.bsky.actor.searchActors`, `app.bsky.feed.searchPosts`, `app.bsky.feed.getSuggestedFeeds`; `loadSuggestions` via `app.bsky.actor.getSuggestions`; cursor pagination per tab
- `SearchScreen`: search bar with clear button; suggestions section (shown on empty query); tab strip (People/Posts/Feeds); result rows; infinite scroll trigger on last item

### Gate
- Module 9 Gate pending: search returns results, hashtag opens post list (needs live API)

---

## 2026-04-24 — Module 8: Profile complete

### BlueskyCore
- `Graph.swift`: `FollowRecord`, `BlockRecord` (both with `$type` CodingKey encoding pattern), `MuteActorRequest`
- `Feed.swift` (profile additions): `PutRecordRequest<T>`, `ProfileRecord` (displayName + description)

### BlueskyProfile (new module)
- `ProfileViewModel` (`@Observable`): `loadProfile` via `app.bsky.actor.getProfile`; per-tab author feed via `app.bsky.feed.getAuthorFeed` (filter: `posts_no_replies` / `posts_with_replies` / `posts_with_media`) and `app.bsky.feed.getActorLikes`; cursor pagination; follow/unfollow (`com.atproto.repo.createRecord`/`deleteRecord`), block/unblock, mute/unmute (`app.bsky.graph.muteActor`/`unmuteActor`); `updateProfile` via `com.atproto.repo.putRecord`; all mutations optimistic with revert
- `ProfileHeaderView`: banner `AsyncImage` + placeholder; `AvatarView` overlapping banner with white border; display name + handle + bio (`RichTextView`); stats row (Following/Followers/Posts); Follow/Unfollow button (`.borderedProminent`/`.bordered`); More `Menu` (block/mute); Edit Profile button for own profile
- `ProfileScreen`: single `ScrollView` + `LazyVStack(pinnedViews: [.sectionHeaders])` for sticky tab strip; `Picker(.segmented)` Posts/Replies/Media/Likes; `PostCard` rows with infinite scroll trigger
- `EditProfileSheet`: `NavigationStack` `Form` — `TextField` for display name, `TextEditor` for bio; Save/Cancel in toolbar

### Bluesky-SwiftUI
- Profile tab wired to `ProfileScreen(actorDID:network:accountStore:viewerDID:)`

### Gate
- Module 8 Gate pending: own profile + other profiles, edit flow, follow/unfollow (needs live API)

---

## 2026-04-24 — Modules 6 + 7: Home Feed and Post Thread complete

### BlueskyCore
- `Feed.swift` expanded: `FeedResponse`, `GetPostThreadResponse`, `ThreadViewPost` (`indirect enum` — required for recursive `parent`/`replies` references), `ThreadPost`, `CreateRecordRequest`/`Response`, `DeleteRecordRequest`, `EmptyResponse`, `LikeRecord`, `RepostRecord`

### BlueskyNetworking
- `ATProtoClient.encoder` date strategy fixed to `.iso8601` — `LikeRecord.createdAt` and `RepostRecord.createdAt` now encode correctly for `com.atproto.repo.createRecord`

### BlueskyFeed (new module)
- `FeedViewModel` (`@Observable`): cursor pagination via `app.bsky.feed.getTimeline` / `app.bsky.feed.getFeed`; `like`/`unlike`/`repost`/`unrepost` via `com.atproto.repo.createRecord`/`deleteRecord`; optimistic updates with revert on failure; `FeedSelection: Hashable` for per-tab view-model cache (`[FeedSelection: FeedViewModel]` dictionary)
- `FeedSwitcherView`: horizontal scroll tab strip — Following (`.timeline`) + Discover (algorithmic `at://` feed URI)
- `FeedView`: `List` with `.refreshable` + infinite scroll on last item via `.onAppear`; error state with retry; `PostCard.Actions` callbacks wired to view model
- `ThreadViewModel` (`@Observable`): loads `app.bsky.feed.getPostThread` (depth=6, parentHeight=80)
- `ThreadView`: recursive tree rendering via `threadNodes(_:) -> AnyView` (not `some View` — `AnyView` required to break self-referential type inference); `.notFound` / `.blocked` placeholder cells; `stableID` for stable `ForEach` identity

### Bluesky-SwiftUI
- Home tab wired to `FeedView`; `@State var threadURI: ATURI?` drives `navigationDestination(isPresented:)` → `ThreadView`
- `project.pbxproj` relative path corrected (`../../BlueskyKit` → `../BlueskyKit`); `BlueskyFeed` product dependency added

### Gate
- Modules 6 + 7 Gates pending: feed loads, scrolls, interactions persist across refresh; thread renders with correct nesting (needs live API)

---

## 2026-04-24 — Module 5: Navigation Shell complete

### Bluesky-SwiftUI (app target)
- `Bluesky_SwiftUIApp.swift` — `AppRoot` bootstrap view: creates `KeychainAccountStore` + `ATProtoClient(accountStore:)` + `SessionManager(accountStore:network:)`; calls `restoreLastSession()`; injects `SessionManager` into SwiftUI environment via `.environment(session)`. `boot()` runs on `@MainActor` via the xcconfig default isolation.
- `ContentView.swift` → `RootView` — reads `SessionManager` from `@Environment(SessionManager.self)`; shows `LoginView(session:onSuccess:)` when `currentAccount == nil`, `MainTabView()` when authenticated.
- `MainTabView.swift` — 5-tab navigation shell:
  - macOS: `NavigationSplitView` with `List(selection:)` sidebar (5 labeled rows with badge counts) + `NavigationStack` in detail panel; toolbar Refresh button
  - iOS: adaptive — `NavigationSplitView` at `.regular` horizontal size class (iPad), `TabView` at `.compact` (iPhone) with per-tab `NavigationStack`
  - `AppTab` enum: `CaseIterable, Identifiable, Hashable` with `title` and `icon` (SF Symbol) properties
  - `messageBadge` / `notificationBadge` state properties for future notification modules
  - `.onOpenURL` deep link handler: `bsky://notifications`, `bsky://messages`, `bsky://profile/…` and `https://bsky.app/…` equivalents

### Bluesky-SwiftUI.xcodeproj/project.pbxproj
- Added `XCLocalSwiftPackageReference "../../BlueskyKit"` to `packageReferences`
- Added 6 `XCSwiftPackageProductDependency` entries: `BlueskyCore`, `BlueskyKit`, `BlueskyAuth`, `BlueskyDataStore`, `BlueskyUI`, `BlueskyNetworking`
- Added 6 `PBXBuildFile` entries (one per product) wired into main target's `Frameworks` build phase
- Updated main target `packageProductDependencies` to list all 6 product IDs

### Build
- `xcodebuild` succeeds with zero errors; only warning is `appintentsmetadataprocessor` finding no App Intents (expected)

---

## 2026-04-24 — Module 4: Design System & Core Components complete

### BlueskyCore
- `FeedGenerator.swift` — `GeneratorView` (feed algorithm view), `GeneratorViewerState`, `GetFeedGeneratorsResponse`, `GetActorFeedsResponse`

### BlueskyUI (new module, fully populated)
- `Theme.swift` — `BlueskyTheme` struct with `.light`, `.dark`, `.dim` palettes; `@Entry public var blueskyTheme`; `.blueskyTheme()` view modifier; packed 24-bit sRGB hex init for colors sourced from the Bluesky ALF design system
- `Tokens.swift` — `Spacing` enum (_2xs=2…_2xl=32, 4pt base grid); `Typography` enum (xs=12…_2xl=28) with font factory and named fonts
- `AvatarView.swift` — `AsyncImage` + initials fallback circle; configurable size
- `RichTextView.swift` — `AttributedString` facet rendering for mention/link/tag; UTF-8 byte-offset → `String.Index` conversion via `samePosition(in:)`
- `PostEmbedView.swift` — renders `BlueskyCore.EmbedView`: image grid (≤4), link card, quote post (with `AvatarView` inline), video thumbnail; `recordWithMedia` handled without recursive `some View` by using `AnyView` for sub-embed
- `PostCard.swift` — full feed post card: repost banner, author header with relative timestamp, `RichTextView` body, `PostEmbedView`, action bar showing reply/repost/like/share counts with filled icons for liked/reposted state; `Actions` struct for interaction callbacks
- `FeedCard.swift` — feed subscription card: avatar, display name, creator handle, description, like count
- `ListCard.swift` — curated/moderation list card: avatar, name, purpose badge (MOD for modlists), creator, description
- `BasicComponents.swift` — `BadgeView` (numeric capsule), `BlueskyButtonStyle` (primary/secondary/destructive/ghost), `BlueskyTextField` (leading icon support), `BlueskyDivider`, `ToastView` + `.toast()` modifier (auto-dismiss), `adaptiveNavigation()` modifier

### Package.swift
- `BlueskyUI` target: added `BlueskyCore` dependency

### Tests
- 38 tests continue to pass (no new test targets needed — UI components validated via `#Preview` blocks)

---

## 2026-04-24 — Module 3: DataStore complete (gate pending app target)

### BlueskyCore
- `Cache.swift` — `CacheResult<T>` value type: carries cached value plus `isExpired` flag; placed in BlueskyCore (no default isolation) so it is freely accessible from any actor context

### BlueskyKit
- `CacheStore.swift` — `CacheStore` protocol: `nonisolated async` store/fetch/evict/evictAll; fetch always returns the entry (even if stale) so callers can implement stale-while-revalidate
- `Bootstrap.swift` — `BlueskyEnvironment` updated with `cache: any CacheStore` property and init parameter

### BlueskyDataStore
- `UserDefaultsPreferencesStore` — `final class, @unchecked Sendable` implementation of `PreferencesStore`; JSON encode/decode; `suiteName` parameter for App Group sharing across extensions
- `SwiftDataCacheStore` — custom actor implementation of `CacheStore`; SwiftData-backed with per-call `ModelContext`; `appGroupIdentifier` parameter for shared container; `static func inMemory()` factory for tests and Xcode Previews

### Package.swift
- `BlueskyDataStore` target: removed `swiftSettings` (no `defaultIsolation`) — same reasoning as `BlueskyNetworking`; module contains custom actors and `@Model` classes that must be non-`@MainActor`
- `BlueskyKitTests` target: added `BlueskyDataStore` dependency

### Tests
- 38 tests pass — added `UserDefaultsPreferencesStore` and `SwiftDataCacheStore` test suites; existing 29 tests continue to pass

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
