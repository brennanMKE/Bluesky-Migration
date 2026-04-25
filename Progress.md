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
| **Active module** | Module 14 — Settings |
| **Active item** | `BlueskySettings` target: appearance, language, notification, account, privacy, content settings |
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
- [x] Add `BlueskyNetworking` target to `BlueskyKit/Package.swift`
- [x] `NetworkClient` protocol in `BlueskyKit`
- [x] `ATProtoClient` with `URLSession` + bearer auth header
- [x] Auto-refresh: intercept 401, use refresh token, retry original request
- [x] Error types in `BlueskyCore`: `ATError` (network, auth, XRPC lexicon errors)
- [x] Cursor pagination type in `BlueskyCore`: `PagedResult<T>`
- [x] Codable lexicon types for all endpoint groups — feed, actor, notification, graph, repo, chat, moderation
  - [x] `app.bsky.feed.*` core types: `PostRecord`, `PostView`, `FeedViewPost`, embed hierarchy, `RichTextFacet`
  - [x] `app.bsky.actor.*` core types: `ProfileBasic`, `ProfileView`, `ProfileDetailed`, `Label`
  - [x] `app.bsky.notification.*`
  - [x] `app.bsky.graph.*` (followers, follows, mutes, blocks, lists)
  - [x] `com.atproto.repo.*` (applyWrites, uploadBlob)
  - [x] `chat.bsky.*` (DM convos, messages, send)
  - [x] Moderation lexicons (labeler, report)
- [ ] **Gate:** Unit test each endpoint group against `public.api.bsky.app`

**Module 5 — Navigation Shell**
- [x] `RootView` in `Bluesky-SwiftUI` app target: auth-gated, shows `LoginView` or `MainTabView`
- [x] `AppRoot` bootstrap: creates `KeychainAccountStore` + `ATProtoClient` + `SessionManager`, calls `restoreLastSession`, injects via `.environment()`
- [x] `MainTabView`: 5 tabs — Home, Search, Messages, Notifications, Profile
- [x] `NavigationStack` per tab; macOS uses `NavigationSplitView` sidebar + `NavigationStack` in detail
- [x] Badge counts on Messages and Notifications tabs (zero now; updated by future notification modules)
- [x] Deep link handler: `bsky://` and `https://bsky.app` URL routing via `.onOpenURL`
- [x] Mac: `NavigationSplitView` sidebar with toolbar Refresh button
- [x] iPad: adaptive layout — `NavigationSplitView` at `.regular` horizontal size class, `TabView` at `.compact`
- [x] `project.pbxproj`: added `BlueskyKit` local package reference + `XCSwiftPackageProductDependency` for all 7 products (BlueskyCore, BlueskyKit, BlueskyAuth, BlueskyDataStore, BlueskyUI, BlueskyNetworking, BlueskyFeed)
- [x] Home tab wired to `FeedView(network:accountStore:onPostTap:)` with `navigationDestination` to `ThreadView`
- [ ] **Gate:** Validate tabs switch, back navigation works, deep links open correct screen (needs Xcode + simulator)

**Module 8 — Profile**
- [x] `BlueskyProfile` target added to `Package.swift`
- [x] `ProfileViewModel`: loadProfile, per-tab author feed with cursor pagination, follow/unfollow/block/unblock/mute/unmute (all optimistic), `updateProfile` (displayName + description)
- [x] `ProfileHeaderView`: banner image, avatar with border, display name + handle, bio, stats row (Following/Followers/Posts), Follow/Unfollow + More action menu
- [x] `ProfileScreen`: sticky tab strip via `pinnedViews`, Posts/Replies/Media/Likes tabs, `LazyVStack` + infinite scroll, `EditProfileSheet` sheet
- [x] `EditProfileSheet`: display name + bio `TextEditor`, Save/Cancel toolbar
- [x] `FollowRecord`, `BlockRecord`, `MuteActorRequest` in `BlueskyCore/Graph.swift`
- [x] `PutRecordRequest<T>`, `ProfileRecord` in `BlueskyCore/Feed.swift`
- [x] Profile tab wired in `MainTabView` via `ProfileScreen(actorDID:network:accountStore:viewerDID:)`
- [ ] Feeds / Lists tabs
- [ ] Verified badges, labeler badges
- [ ] Known followers chip
- [ ] **Gate:** Own profile + other profiles, edit flow, follow/unfollow (needs live app)

**Module 6 — Home Feed**
- [x] `BlueskyFeed` target added to `Package.swift`
- [x] `FeedViewModel`: cursor pagination, loadInitial/loadMore/refresh, like/unlike/repost/unrepost with optimistic updates
- [x] `FeedSwitcherView`: horizontal tab strip — Following (`.timeline`) + Discover (algorithmic)
- [x] `FeedView`: infinite scroll via `.onAppear`, pull-to-refresh via `.refreshable`, error state with retry
- [x] `FeedSelection: Hashable` — view model cache keyed by selection
- [x] Optimistic updates via `updatePost(uri:transform:)` with revert on failure
- [x] ISO 8601 date encoding fixed in `ATProtoClient.encoder` for mutation payloads
- [x] `FeedViewPost`, `LikeRecord`, `RepostRecord`, `CreateRecordRequest/Response`, `DeleteRecordRequest`, `EmptyResponse` in `BlueskyCore`
- [ ] Filter: hide replies/reposts toggles (per feed)
- [ ] **Gate:** Feed loads, scrolls, interactions persist across refresh (needs live app)

**Module 7 — Post Thread**
- [x] `GetPostThreadResponse`, `ThreadViewPost` (`indirect enum`), `ThreadPost` in `BlueskyCore`
- [x] `ThreadViewModel`: loads `app.bsky.feed.getPostThread` with depth=6, parentHeight=80
- [x] `ThreadView`: recursive tree via `threadNodes` returning `AnyView` (breaks self-referential `some View` error); `postNode` renders each `ThreadPost`; `stableID` for `ForEach`
- [x] `.notFound` / `.blocked` placeholder cells
- [ ] Reply composer inline or as sheet
- [ ] Inline post expansion
- [ ] **Gate:** Full thread renders with correct reply nesting (needs live app)

**Module 4 — Design System & Core Components**
- [x] `Theme`: light / dark / dim palettes, `@Entry` env key, `.blueskyTheme()` view modifier
- [x] Spacing tokens: `Spacing._2xs…_2xl` (CGFloat constants, 4pt base grid)
- [x] Typography: `Typography.xs…_2xl` sizes + font factory; `bodySmall/body/headline/title/largeTitle`
- [x] `AvatarView`: `AsyncImage` + initials fallback + circular clip
- [x] `RichTextView`: `AttributedString` facet rendering for mention/link/tag; byte-offset → String.Index conversion
- [x] `PostEmbedView`: image grid (≤4), link card, quote post, video thumbnail, recordWithMedia compound
- [x] `PostCard`: repost banner, author header, `RichTextView` body, `PostEmbedView`, action bar with like/repost state
- [x] `FeedCard`: feed name, description, creator handle, like count
- [x] `ListCard`: list name, purpose badge (MOD), creator, description
- [x] `BlueskyButtonStyle` (primary/secondary/destructive/ghost), `BlueskyTextField`, `BlueskyDivider`, `BadgeView`
- [x] `ToastView` + `.toast()` modifier (auto-dismiss after configurable duration)
- [x] `adaptiveNavigation()` modifier
- [ ] `#Preview` canvas validation (needs Xcode + simulator — all components have preview blocks)
- [ ] **Gate:** Component gallery covers all states

**Module 3 — DataStore** _(starts after Module 2 gate passes)_
- [x] Storage protocols in `BlueskyKit`: `AccountStore`, `PreferencesStore`, `CacheStore`
  - [x] `AccountStore` protocol (with `nonisolated` requirements)
  - [x] `PreferencesStore` protocol (with `nonisolated` requirements)
  - [x] `CacheStore` protocol
- [x] `KeychainAccountStore`
- [x] `UserDefaultsPreferencesStore`
- [x] `SwiftDataCacheStore`
- [x] App group container setup
- [ ] **Gate:** Preferences survive restart; cache serves stale while fresh fetch loads

**Module 9 — Search & Discovery**
- [x] `BlueskySearch` target added to `Package.swift`
- [x] `SearchViewModel`: actors/posts/feeds tabs, 300ms debounced search, `loadSuggestions` via `app.bsky.actor.getSuggestions`
- [x] `SearchScreen`: search bar, suggestions section (empty query), tab strip + result rows; infinite scroll on last item
- [ ] Trending topics section
- [ ] Hashtag view / Topic view
- [ ] **Gate:** Search returns results, hashtag opens post list (needs live app)

**Module 10 — Notifications**
- [x] `BlueskyNotifications` target added to `Package.swift`
- [x] `NotificationsViewModel`: `loadInitial/loadMore/refresh/markSeen/fetchUnreadCount`; `unreadCount: Int` for badge
- [x] `NotificationsScreen`: List with NotificationRow + reason icons; pull-to-refresh; infinite scroll; markSeen on `.task`
- [ ] Grouped notifications
- [ ] Push notification receipt → open thread
- [ ] **Gate:** Notification list updates, badge clears on open (needs live app)

**Module 11 — Direct Messages**
- [x] `BlueskyMessages` target added to `Package.swift`
- [x] `MessagesViewModel`: `loadInitial/loadMore/refresh/leaveConvo/muteConvo` via `chat.bsky.convo.*`; optimistic updates
- [x] `MessageThreadViewModel`: `load/loadOlder/sendMessage/markRead`; `isOwn(_:)` for bubble alignment
- [x] `ConversationListScreen`: ConvoRow + unread badge; swipe actions (Leave, Mute/Unmute); `navigationDestination` → `MessageThreadScreen`
- [x] `MessageThreadScreen`: `ScrollViewReader` + `LazyVStack`; chat bubbles (own=accent right, other=secondary left); compose bar
- [ ] Send image attachment; group chat settings; message requests inbox
- [ ] **Gate:** Send/receive messages (needs live app)

**Module 12 — Composer**
- [x] `BlueskyComposer` target added to `Package.swift`
- [x] `FacetBuilder`: UTF-8 byte-accurate `#hashtag` + `@mention` facets via Swift regex + `samePosition(in: utf8)`
- [x] `ComposerViewModel`: upload images (blob → EmbedImage), build embed, create PostRecord; 200ms debounced mention autocomplete
- [x] `ComposerSheet`: TextEditor + mention overlay + quote preview + image grid + alt text popover + language picker + character counter; iOS `PHPickerRepresentable`
- [x] `NetworkClient.upload(lexicon:data:mimeType:)` added; implemented in `ATProtoClient` as raw `httpBody` POST
- [ ] Video picker + upload; link card preview; thread/multi-post; draft persistence
- [ ] **Gate:** Post with text, images, mention (needs live app)

**Module 13 — Moderation**
- [x] `BlueskyModeration` target added to `Package.swift`
- [x] `ModerationViewModel`: load muted/blocked accounts; moderation lists; content label settings; adult content toggle
- [x] `MutesScreen` + `BlocksScreen`: lists with unblock/unmute swipe actions
- [x] `ModerationListsScreen`: subscribe/unsubscribe to labeler lists
- [x] `ContentFilterSettingsScreen`: per-label hide/warn/show picker; adult content toggle
- [x] `ReportDialog`: report post, profile, or list via `com.atproto.moderation.createReport`
- [ ] **Gate:** Mute/block applies immediately; labeler settings filter content (needs live app)

**Module 14 — Settings**
- [ ] `BlueskySettings` target added to `Package.swift`
- [ ] `SettingsViewModel`: load and save preferences (theme, language, notification prefs, privacy)
- [ ] `SettingsScreen`: hub with navigation to sub-sections; "Moderation" row links to `ModerationScreen`
- [ ] `AppearanceSettingsScreen`: theme picker (light/dark/dim), font size
- [ ] `LanguageSettingsScreen`: post languages, app language
- [ ] `NotificationSettingsScreen`: per-type push notification toggles
- [ ] `AccountSettingsScreen`: email, password change, 2FA toggle, app passwords
- [ ] `PrivacySettingsScreen`: activity privacy, interaction settings
- [ ] `ContentSettingsScreen`: autoplay video, external embeds, alt text requirement
- [ ] `AboutScreen`: version, open-source licenses, legal links
- [ ] **Gate:** Each setting persists and takes immediate effect (needs live app)

---

## Completion Log

_Append entries here as items are finished. Most recent at the top._

| Date | Module | Item |
|------|--------|------|
| 2026-04-24 | BlueskyModeration | `ReportDialog`: polymorphic subject (account/record), reason picker, details text; calls `com.atproto.moderation.createReport` |
| 2026-04-24 | BlueskyModeration | `ContentFilterSettingsScreen`: adult content toggle + per-label hide/warn/show pickers; saves via `app.bsky.actor.putPreferences` |
| 2026-04-24 | BlueskyModeration | `ModerationListsScreen`: subscribed mod lists with Unsubscribe action via `app.bsky.graph.unmuteActorList` |
| 2026-04-24 | BlueskyModeration | `MutesScreen` + `BlocksScreen`: paginated lists with Unmute/Unblock optimistic actions |
| 2026-04-24 | BlueskyModeration | `ModerationViewModel`: getMutes/getBlocks/getLists/getPreferences/putPreferences + all mutations |
| 2026-04-24 | BlueskyCore | `GetListResponse`, `ListItemView`, `ListMuteRequest`, `ContentLabelPref`, `GetPreferencesResponse`, `PutPreferencesRequest` added to Moderation.swift |
| 2026-04-24 | Bluesky-SwiftUI | Module 13 Gate pending: mute/block applies immediately (needs live API) |
| 2026-04-24 | BlueskyComposer | `NetworkClient.upload` + `ATProtoClient.performUpload` (raw blob POST); `PreviewNetworkClient` + `MockNetworkClient` updated |
| 2026-04-24 | BlueskyComposer | `FacetBuilder`: UTF-8 byte-accurate `#hashtag`/`@mention` facets via Swift regex + `samePosition(in:)` |
| 2026-04-24 | BlueskyComposer | `ComposerViewModel`: image upload pipeline, embed assembly (images/record/recordWithMedia), mention autocomplete debounced 200ms |
| 2026-04-24 | BlueskyComposer | `ComposerSheet`: TextEditor + mention overlay + image grid + alt text popover + language picker + character counter + `PHPickerRepresentable` |
| 2026-04-24 | Bluesky-SwiftUI | Module 12 Gate pending: post with text/images/mentions (needs live API) |
| 2026-04-24 | BlueskyMessages | `MessageThreadScreen`: ScrollViewReader + LazyVStack chat bubbles; compose bar with send |
| 2026-04-24 | BlueskyMessages | `ConversationListScreen`: ConvoRow + unread badge; swipe Leave/Mute; navigationDestination → MessageThreadScreen |
| 2026-04-24 | BlueskyMessages | `MessageThreadViewModel`: load/loadOlder/sendMessage/markRead; `isOwn(_:)` for bubble side |
| 2026-04-24 | BlueskyMessages | `MessagesViewModel`: loadInitial/loadMore/refresh/leaveConvo/muteConvo with optimistic updates |
| 2026-04-24 | Bluesky-SwiftUI | Module 11 Gate pending: send/receive DMs (needs live API) |
| 2026-04-24 | BlueskyNotifications | `NotificationsScreen`: List + NotificationRow + reason icons; pull-to-refresh; infinite scroll; markSeen on .task |
| 2026-04-24 | BlueskyNotifications | `NotificationsViewModel`: loadInitial/loadMore/refresh/markSeen/fetchUnreadCount; unreadCount for badge |
| 2026-04-24 | Bluesky-SwiftUI | Module 10 Gate pending: notification list + badge (needs live API) |
| 2026-04-24 | BlueskySearch | `SearchScreen`: search bar + clear; suggestions (empty query); people/posts/feeds tab strip; infinite scroll |
| 2026-04-24 | BlueskySearch | `SearchViewModel`: actors/posts/feeds tabs; 300ms debounced search; `loadSuggestions` via getSuggestions |
| 2026-04-24 | BlueskyCore | `Search.swift`: `SearchActorsResponse`, `SearchActorsTypeaheadResponse`, `GetSuggestionsResponse`, `SearchPostsResponse`, `GetSuggestedFeedsResponse` |
| 2026-04-24 | Bluesky-SwiftUI | Module 9 Gate pending: search results (needs live API) |
| 2026-04-24 | Bluesky-SwiftUI | Module 8 Gate pending: validate profile screen with live API |
| 2026-04-24 | BlueskyProfile | `ProfileScreen`: sticky tab strip (pinnedViews), Posts/Replies/Media/Likes tabs, lazy per-tab feed loading |
| 2026-04-24 | BlueskyProfile | `ProfileHeaderView`: banner, avatar, stats, Follow button, More menu (block/mute) |
| 2026-04-24 | BlueskyProfile | `ProfileViewModel`: loadProfile, loadFeed/loadMoreFeed per tab, follow/unfollow/block/unblock/mute/unmute, updateProfile |
| 2026-04-24 | BlueskyProfile | `EditProfileSheet`: display name + bio form (avatar upload deferred) |
| 2026-04-24 | BlueskyCore | `FollowRecord`, `BlockRecord`, `MuteActorRequest` in Graph.swift |
| 2026-04-24 | BlueskyCore | `PutRecordRequest<T>`, `ProfileRecord` in Feed.swift |
| 2026-04-24 | Bluesky-SwiftUI | Module 6/7 Gate pending: wire app to live Bluesky API to validate feed + thread |
| 2026-04-24 | Bluesky-SwiftUI | `MainTabView` Home tab wired to `FeedView`; `navigationDestination` → `ThreadView` |
| 2026-04-24 | Bluesky-SwiftUI.xcodeproj | Fixed `XCLocalSwiftPackageReference` relative path `../../BlueskyKit` → `../BlueskyKit`; added BlueskyFeed product dependency |
| 2026-04-24 | BlueskyFeed | `ThreadView` + `ThreadViewModel`: recursive tree renderer using `AnyView` to break self-referential `some View` error |
| 2026-04-24 | BlueskyFeed | `FeedView` + `FeedViewModel` + `FeedSwitcherView`: infinite scroll, pull-to-refresh, like/repost with optimistic updates |
| 2026-04-24 | BlueskyCore | `Feed.swift`: `FeedResponse`, `ThreadViewPost` (indirect enum), `ThreadPost`, `GetPostThreadResponse`, `CreateRecordRequest/Response`, `DeleteRecordRequest`, `EmptyResponse`, `LikeRecord`, `RepostRecord` |
| 2026-04-24 | BlueskyNetworking | `ATProtoClient.encoder` fixed to use `.iso8601` date encoding strategy |
| 2026-04-24 | Bluesky-SwiftUI | Module 5 Gate pending: validate tabs/nav/deep links in Xcode + simulator |
| 2026-04-24 | Bluesky-SwiftUI | `project.pbxproj`: linked BlueskyCore, BlueskyKit, BlueskyAuth, BlueskyDataStore, BlueskyUI, BlueskyNetworking via `XCLocalSwiftPackageReference` + `XCSwiftPackageProductDependency` |
| 2026-04-24 | Bluesky-SwiftUI | `MainTabView`: macOS sidebar (`NavigationSplitView`), iOS/iPadOS adaptive (split view or tab bar), badge counts, deep link handler |
| 2026-04-24 | Bluesky-SwiftUI | `RootView`: auth gate — `LoginView` when no session, `MainTabView` when authenticated |
| 2026-04-24 | Bluesky-SwiftUI | App bootstrap: `AppRoot` creates `KeychainAccountStore` + `ATProtoClient` + `SessionManager`, restores last session, injects into SwiftUI environment |
| 2026-04-24 | BlueskyUI | `adaptiveNavigation()` view modifier |
| 2026-04-24 | BlueskyUI | `ToastView` + `.toast()` modifier (auto-dismiss, error variant) |
| 2026-04-24 | BlueskyUI | `BlueskyButtonStyle` (primary/secondary/destructive/ghost), `BlueskyTextField`, `BlueskyDivider`, `BadgeView` |
| 2026-04-24 | BlueskyUI | `ListCard` — curated list card with MOD purpose badge |
| 2026-04-24 | BlueskyUI | `FeedCard` — feed subscription card with creator, like count |
| 2026-04-24 | BlueskyUI | `PostCard` — full feed post with repost banner, action bar, like/repost state |
| 2026-04-24 | BlueskyUI | `PostEmbedView` — image grid, link card, quote post, video thumbnail, recordWithMedia compound |
| 2026-04-24 | BlueskyUI | `RichTextView` — `AttributedString` facet rendering; byte-offset → String.Index conversion |
| 2026-04-24 | BlueskyUI | `AvatarView` — `AsyncImage` + initials fallback, circular clip |
| 2026-04-24 | BlueskyUI | `Tokens` — `Spacing` and `Typography` enums with static constants |
| 2026-04-24 | BlueskyUI | `Theme` — light/dark/dim color palettes; `@Entry` env key; `.blueskyTheme()` modifier |
| 2026-04-24 | BlueskyCore | `GeneratorView`, `GeneratorViewerState`, `GetFeedGeneratorsResponse`, `GetActorFeedsResponse` (FeedGenerator.swift) |
| 2026-04-24 | BlueskyDataStore | `SwiftDataCacheStore` actor: SwiftData-backed `CacheStore`; per-call `ModelContext`; in-memory factory for tests; `appGroupIdentifier` support |
| 2026-04-24 | BlueskyDataStore | `UserDefaultsPreferencesStore` final class: `@unchecked Sendable`; `suiteName` for App Group sharing |
| 2026-04-24 | BlueskyKit | `CacheStore` protocol: `nonisolated async` store/fetch/evict/evictAll |
| 2026-04-24 | BlueskyCore | `CacheResult<T>` struct in `BlueskyCore` (no default isolation — freely accessible from any actor context) |
| 2026-04-24 | BlueskyKit | `BlueskyEnvironment` now includes `cache: any CacheStore` |
| 2026-04-24 | BlueskyCore | Moderation lexicons: `ReportSubjectRepo`, `ReportSubjectRecord`, `CreateReportRequest/Response`, `LabelerView` |
| 2026-04-24 | BlueskyCore | `chat.bsky.*` types: `ConvoView`, `MessageView`, `MessageSender`, `MessageInput`, `SendMessageRequest`, `ListConvosResponse`, `GetMessagesResponse` |
| 2026-04-24 | BlueskyCore | `com.atproto.repo.*` types: `UploadBlobResponse`, `WriteCreate`, `WriteDelete`, `WriteOp`, `ApplyWritesRequest/Response`, `RepoCommit`, `AnyEncodable` |
| 2026-04-24 | BlueskyCore | `app.bsky.graph.*` types: `GetFollowersResponse`, `GetFollowsResponse`, `GetMutesResponse`, `GetBlocksResponse`, `GetListsResponse`, `ListView` |
| 2026-04-24 | BlueskyCore | `app.bsky.notification.*` types: `NotificationView`, `ListNotificationsResponse`, `UpdateSeenRequest`, `RegisterPushRequest` |
| 2026-04-24 | BlueskyNetworking | `ATProtoClient` actor: URLSession + bearer auth + 401 auto-refresh + token rotation via `refreshSession` |
| 2026-04-24 | Package.swift | `BlueskyNetworking` target added (actor-isolated, no `defaultIsolation`) |
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

**2026-04-24 — Module 13 (BlueskyModeration) complete; Module 14 (Settings) next**

`BlueskyModeration` target built and linked into the Xcode app:

- `ModerationViewModel` (`@Observable`): `loadMutes`/`loadMoreMutes`, `loadBlocks`/`loadMoreBlocks`, `loadModLists`/`loadMoreModLists`, `loadPreferences`; mutations `unmute(did:)`, `unblock(profile:)`, `muteList/unmuteList`, `setAdultContent`, `setLabelVisibility`, `report(subject:reasonType:reason:)`; all mutations optimistic with revert on failure.
- `MutesScreen` / `BlocksScreen`: paginated lists via `getMutes`/`getBlocks` with `ContentUnavailableView` on empty state; Unmute/Unblock buttons with role=.destructive; infinite scroll trigger on last row.
- `ModerationListsScreen`: lists filtered to `app.bsky.graph.defs#modlist` purpose; Unsubscribe via `unmuteActorList`.
- `ContentFilterSettingsScreen`: adult content `Toggle` gated section; per-label `Picker(.menu)` for hide/warn/show (porn, sexual, nudity, graphic-media, hate, spam).
- `ReportDialog`: `NavigationStack` form with reason `Picker(.inline)` + optional `TextEditor`; submits via `com.atproto.moderation.createReport` with `ReportSubjectRepo` or `ReportSubjectRecord`; success `.alert` auto-dismisses.
- `ModerationScreen`: hub `List` with nav links to all sub-screens.
- `MainTabView` Profile tab toolbar gains a shield button (🛡) → `ModerationScreen` via `navigationDestination`.

New `BlueskyCore/Moderation.swift` types:
- `GetListResponse` + `ListItemView` for `app.bsky.graph.getList`
- `ListMuteRequest` for `muteActorList`/`unmuteActorList`
- `ContentLabelPref` (label, visibility, labelerDid)
- `GetPreferencesResponse`: custom decoder that parses polymorphic `$type` array — extracts `adultContentPref` and `contentLabelPref` items
- `PutPreferencesRequest`: holds `[AnyEncodable]`; private nested `_AdultPref`/`_LabelPref` encode with `$type`

Key decisions:
- `ContentLabelPref` is `Sendable` only (not `Codable`) — decoded via `GetPreferencesResponse`'s custom decoder; encoded via `PutPreferencesRequest`'s private helpers.
- `ReportDialog` takes a `ReportSubjectKind` enum rather than a generic subject, keeping the call site simple without leaking AT Protocol types.
- `ModerationScreen` wired into Profile tab (not Settings) since Settings doesn't exist yet; will be relocated when Module 14 is built.

**Next session:** Module 14 — Settings (`BlueskySettings` target).

---

**2026-04-24 — Modules 9–12 complete; Module 13 (Moderation) next**

Four modules implemented in one session; all link into the Xcode app target:

- **Module 9 (BlueskySearch):** `SearchViewModel` with 300ms debounced search across actors/posts/feeds + `loadSuggestions`; `SearchScreen` with search bar, empty-state suggestions, tab strip, infinite scroll. Added `Search.swift` lexicon types to `BlueskyCore`.
- **Module 10 (BlueskyNotifications):** `NotificationsViewModel` (loadInitial/loadMore/refresh/markSeen/fetchUnreadCount, `unreadCount` for tab badge); `NotificationsScreen` (List + reason icons for like/repost/follow/mention/quote/reply, pull-to-refresh, infinite scroll, markSeen on `.task`).
- **Module 11 (BlueskyMessages):** `MessagesViewModel` (chat.bsky.convo.listConvos; leaveConvo/muteConvo with optimistic updates); `MessageThreadViewModel` (load/loadOlder/sendMessage/markRead; `isOwn` for bubble side); `ConversationListScreen` (ConvoRow + unread badge, swipe Leave/Mute, navigationDestination); `MessageThreadScreen` (ScrollViewReader + LazyVStack bubbles, compose bar).
- **Module 12 (BlueskyComposer):** `FacetBuilder` (UTF-8 byte-accurate hashtag/mention facets); `ComposerViewModel` (image upload → EmbedImage, embed assembly, createRecord, mention autocomplete); `ComposerSheet` (TextEditor + mention overlay + image grid + alt text popover + language picker + character counter + `PHPickerRepresentable`). Added `NetworkClient.upload` + `ATProtoClient.performUpload`.

Key patterns:
- `navigationDestination(isPresented:)` used instead of `(item:)` when the item type lacks `Hashable` — drives navigation with a `Bool` binding derived from an optional.
- `Cursor` is a `typealias` for `String` — no `.rawValue`; use cursor string directly.
- `EmbedRecordRef` and `PostRef` are distinct types both carrying `uri: ATURI` + `cid: CID`; `Embed.record` takes `EmbedRecordRef`.
- `FacetFeature` enum cases use argument labels: `.tag(tag:)`, `.mention(did:)`, `.link(uri:)`.
- `MessageThreadScreen.convoTitle` needs `viewerDID: DID?` stored on the view struct, not derived from the view model's `convoId: String`.

All gates for Modules 9–12 require a live Bluesky account in the running app (simulator/device).

**Next session:** Module 13 — Moderation (`BlueskyModeration` target).

---

**2026-04-24 — Foundation complete; concurrency model settled**

All `BlueskyCore` types and `BlueskyKit` protocols are in place. The `swift test` suite passes with 9 tests. Key pattern to remember for all future modules:

- `BlueskyCore` types are plain Swift value types — no `@MainActor`, no `nonisolated`. They just work from any context.
- Protocol requirements in `BlueskyKit` that are I/O-bound (AccountStore, PreferencesStore, NetworkClient) carry `nonisolated` so their implementations can be actors.
- Protocol requirements in `BlueskyKit` that carry UI state (SessionManaging) are `@MainActor` by default from the module isolation setting — leave them that way.
- Test mocks for `@MainActor` protocols → `@MainActor final class`. Test mocks for `nonisolated` protocols → `final class, @unchecked Sendable` (test target has no default isolation, so methods are nonisolated by default).
- `Embed` and `EmbedView` are `indirect enum` because `recordWithMedia` nests the same type recursively.

**Next session:** Start with `KeychainAccountStore` in `BlueskyDataStore`. The `AccountStore` protocol is ready; the Keychain wrapper is the first concrete I/O implementation.

---

**2026-04-24 — Module 8 (BlueskyProfile) core implementation complete; gate needs live API**

`BlueskyProfile` target built and linked into the Xcode app:

- `ProfileViewModel` (`@Observable`): `loadProfile` via `app.bsky.actor.getProfile`; per-tab author feed via `app.bsky.feed.getAuthorFeed` (filter: `posts_no_replies` / `posts_with_replies` / `posts_with_media`) and `app.bsky.feed.getActorLikes`; cursor pagination; follow/unfollow (`com.atproto.repo.createRecord` / `deleteRecord`), block/unblock, mute/unmute (`app.bsky.graph.muteActor` / `unmuteActor`); `updateProfile` via `com.atproto.repo.putRecord` (collection `app.bsky.actor.profile`, rkey `"self"`); all mutations use optimistic UI with revert on failure.
- `ProfileHeaderView`: banner `AsyncImage` + placeholder; avatar `AvatarView` overlapping banner with white border; display name + handle + bio; stats row (Following/Followers/Posts); Follow/Unfollow button with `.borderedProminent` / `.bordered` style; More `Menu` with block/mute actions; Edit Profile button for own profile.
- `ProfileScreen`: single outer `ScrollView` + `LazyVStack(pinnedViews: [.sectionHeaders])` so the tab strip sticks while scrolling through posts; `Picker(.segmented)` for Posts/Replies/Media/Likes; post rows use `PostCard` from `BlueskyUI` with infinite scroll trigger on last row.
- `EditProfileSheet`: `NavigationStack` with `Form` — `TextField` for display name, `TextEditor` for bio; Save/Cancel in toolbar.
- Added `FollowRecord` + `BlockRecord` (with `$type` CodingKey pattern) and `MuteActorRequest` to `BlueskyCore/Graph.swift`.
- Added `PutRecordRequest<T>` and `ProfileRecord` to `BlueskyCore/Feed.swift`.
- `MainTabView` Profile tab now shows `ProfileScreen(actorDID: account.did, ...)` when logged in.
- Xcode build succeeds.

Key decisions:
- `ProfileScreen` uses a single `ScrollView` + `LazyVStack` (not nested `List` inside `ScrollView`) to avoid nested scrollable view issues on iOS.
- `ThreadView` in the profile context uses a `ThreadPlaceholder` stub to avoid a circular `BlueskyProfile → BlueskyFeed` dependency. The app target wires the real `ThreadView` in a future integration step.
- `ProfileRecord` for `putRecord` encodes only `displayName` and `description` (avatar upload requires `com.atproto.repo.uploadBlob` which is deferred).

**Gates remaining**: Modules 6, 7, 8 gates all need live Bluesky credentials; Module 5 needs simulator for tabs/nav/deep links.

**Next session:** Module 9 — Search & Discovery (`BlueskySearch` target).

---

**2026-04-24 — Modules 6 + 7 (BlueskyFeed) complete; app shell wired; gate needs live API**

`BlueskyFeed` target is fully built and linked into the Xcode app:

- `FeedViewModel` (`@Observable`): cursor pagination via `app.bsky.feed.getTimeline` / `app.bsky.feed.getFeed`; `like`/`unlike`/`repost`/`unrepost` via `com.atproto.repo.createRecord` / `deleteRecord`; optimistic updates with revert on failure; `FeedSelection: Hashable` for view model caching per tab.
- `FeedSwitcherView`: horizontal scroll tab strip — Following (`.timeline`) and Discover (`at://did:plc:.../whats-hot`).
- `FeedView`: `List` with `.refreshable` + infinite scroll via `.onAppear` on the last item; error state with retry; `PostCard.Actions` wired to `FeedViewModel`.
- `ThreadViewModel`: loads `app.bsky.feed.getPostThread` (depth=6, parentHeight=80).
- `ThreadView`: recursive tree rendering via `threadNodes(_:) -> AnyView` (not `some View`) — `AnyView` is required here to break the self-referential type inference that Swift cannot resolve for recursive `@ViewBuilder` functions.
- `MainTabView` Home tab now uses `FeedView`; `@State private var threadURI: ATURI?` drives a `navigationDestination(isPresented:)` to `ThreadView`.
- `ATProtoClient.encoder` was missing `.iso8601` date encoding — fixed; `LikeRecord.createdAt` and `RepostRecord.createdAt` now encode correctly.
- `project.pbxproj` relative path was `../../BlueskyKit` (resolved to `/Users/brennan/Developer/BlueskyKit`) — fixed to `../BlueskyKit` (resolves to `/Users/brennan/Developer/ReactNative/BlueskyKit`). App builds successfully with `xcodebuild`.
- 49 tests pass in the Swift package.

Key patterns:
- `indirect enum ThreadViewPost` — required because `ThreadPost.parent: ThreadViewPost?` and `replies: [ThreadViewPost]?` reference the enclosing enum recursively.
- Recursive `some View` → use `AnyView` only for the recursive call; all non-recursive branches remain typed.
- `navigationDestination(isPresented: Binding(...))` with a computed `Binding<Bool>` from an optional `ATURI` state — avoids needing `Identifiable` conformance on `ATURI`.
- `FeedSelection: Hashable` allows `[FeedSelection: FeedViewModel]` dictionary as a view-model cache so each feed tab gets its own independent pagination state.

**Gates remaining**: Module 6 gate (feed loads/scrolls/interactions) and Module 7 gate (thread tree renders) both need a running app with live Bluesky credentials. Module 5 gate (tabs/nav/deep links) also still pending.

**Next session:** Module 8 — Profile screen (`BlueskyProfile` target): profile header, posts/replies/media/likes tabs, follow/unfollow actions.

---

**2026-04-24 — Module 5 Navigation Shell complete (gate needs Xcode/simulator)**

All Module 5 implementation items are done. The `Bluesky-SwiftUI` Xcode project now builds as a full app shell:
- `project.pbxproj` manually updated with `XCLocalSwiftPackageReference` for `../../BlueskyKit` and `XCSwiftPackageProductDependency` entries for all 6 modules. Also added `PBXBuildFile` entries wired into the main target's Frameworks build phase.
- `Bluesky_SwiftUIApp`: creates `KeychainAccountStore` + `ATProtoClient` + `SessionManager` in a `@MainActor` `boot()` task, calls `restoreLastSession()`, then injects the `SessionManager` via `.environment()` into `RootView`.
- `RootView` reads `SessionManager` from `@Environment` and shows `LoginView` or `MainTabView`.
- `MainTabView`: macOS uses `NavigationSplitView` (sidebar + `NavigationStack` detail); iOS uses adaptive layout (`NavigationSplitView` at `.regular` size class, `TabView` at `.compact`); `.onOpenURL` handles `bsky://` and `https://bsky.app` deep links; `messageBadge`/`notificationBadge` state ready for future notification modules.
- `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` in `Build.xcconfig` — the app target has `@MainActor` as default isolation, same as `BlueskyAuth` / `BlueskyUI`. No explicit `@MainActor` annotations needed in app code.
- `MemberImportVisibility` feature is enabled — must explicitly `import BlueskyCore` to access `Account.handle` even when `BlueskyAuth` transitively imports it.

**With Module 5 in place**, the Module 1 gate (login → kill → relaunch → session restored) can now be tested in Xcode. Modules 3 and 4 gates also become testable once the app target is running.

**Next session:** Start Module 6 — Home Feed (`BlueskyFeed` target): feed list with cursor pagination, pull-to-refresh, feed switcher, post card interactions.

---

**2026-04-24 — Module 4 Design System complete (gate needs Xcode/simulator)**

All Module 4 implementation items are done. Key design decisions:
- `CacheResult`, `GeneratorView` → `BlueskyCore` (no default isolation, accessible from any actor context)
- `BlueskyTheme.Colors` uses packed 24-bit sRGB hex init (e.g., `0xFF_85_00`) — avoids magic float conversions
- `@Entry public var blueskyTheme` uses iOS 18 / macOS 15 `@Entry` macro to reduce `EnvironmentKey` boilerplate
- `PostEmbedView` uses `AnyView` only for the `recordWithMedia` sub-embed call — avoids self-referential `some View` compile error on the recursive branch; rest of the view uses `@ViewBuilder`
- `RichTextView` byte-offset conversion: `utf8.index(utf8.startIndex, offsetBy:)` → `samePosition(in: text)` → `Range(_, in: attributedString)`
- `PostCard` and `FeedCard` use `theme.colors.link` / `.like` / `.success` for interactive state colors

**Module 4 Gate**: All components have `#Preview` blocks and should render correctly in Xcode Canvas. Full validation requires opening the package in Xcode with a simulator. The gate check (component gallery) will be done when Module 5 (app shell) adds a `ComponentGalleryView`.

**Next session:** Module 5 — Navigation Shell in `Bluesky-SwiftUI` app target: `RootView` (auth-gated), `MainTabView` (5 tabs), `NavigationStack` per tab. This is the first module that builds the actual app target.

---

**2026-04-24 — Module 3 DataStore complete (gate pending app target)**

All Module 3 implementation items are done:
- `CacheResult<T>` value type moved to `BlueskyCore` (no default isolation) — ensures it can be constructed and accessed from any actor context without `@MainActor` restrictions
- `CacheStore` protocol in `BlueskyKit`: `nonisolated async` store/fetch/evict/evictAll; fetch returns stale entries with `isExpired` flag for stale-while-revalidate
- `UserDefaultsPreferencesStore` in `BlueskyDataStore`: `final class, @unchecked Sendable`; JSON encode/decode; `suiteName` for App Group support
- `SwiftDataCacheStore` in `BlueskyDataStore`: custom actor; per-call `ModelContext` (lightweight, avoids cross-context change-tracking); `appGroupIdentifier` for shared container; `inMemory()` factory for tests/previews
- `BlueskyEnvironment` updated to include `cache: any CacheStore`
- 38 tests pass

Key patterns for Module 3:
- `BlueskyDataStore` now has **no** `defaultIsolation` (like `BlueskyNetworking`) — it contains custom actors and `@Model` classes that must be usable from non-`@MainActor` contexts
- `CacheResult<T>` belongs in `BlueskyCore`, not `BlueskyKit` — same reasoning as `PagedResult<T>`: it's a pure value-type envelope with no actor isolation requirements
- `nonisolated let` on struct properties in a `defaultIsolation(MainActor.self)` module is NOT sufficient; the right fix is to put the struct in `BlueskyCore`
- `SwiftDataCacheStore` uses per-call `ModelContext(container)` — creates a new context per operation. This is correct because each operation calls `ctx.save()` before returning, making the persisted state visible to subsequent contexts

**Module 3 Gate** requires the `Bluesky-SwiftUI` app target (Module 5). Start Module 4 (Design System) now.

**Next session:** Module 4 — `BlueskyUI` design system: `Theme` palettes, spacing tokens, typography scale, then `PostCard`, `AvatarView`, `RichTextView`.

---

**2026-04-24 — Module 2 lexicon types complete; gate pending API credentials**

All Module 2 implementation items are done:
- `BlueskyNetworking` target in `Package.swift` (no `defaultIsolation` — `ATProtoClient` is a custom actor)
- `ATProtoClient` actor: bearer auth, 401 intercept → refresh-token → retry, token saved back to `AccountStore`
- All lexicon Codable types in `BlueskyCore`: notification, graph, repo (applyWrites/uploadBlob), chat.bsky, moderation
- 24 tests pass — Codable round-trips for every new type

Key patterns for Module 2:
- `BlueskyNetworking` uses **no** `defaultIsolation`. `ATProtoClient` is a custom `actor`, and its private decoders run in the actor's isolation, not on `@MainActor`.
- `nonisolated` wrappers (`get`, `post`) call `await` into actor-isolated `performGet`/`performPost` helpers — the canonical pattern for satisfying `nonisolated` protocol requirements with an actor.
- `AnyEncodable` type-erases `Encodable & Sendable` using a `@Sendable` closure so heterogeneous write operations can live in a concrete array (`[WriteOp]`).
- Chat API namespace is `chat.bsky.*` not `app.bsky.chat.*`.

**Module 2 Gate** requires Bluesky credentials to hit `public.api.bsky.app`. Defer the live integration tests until the app target exists (Module 5) and we can wire up a real `KeychainAccountStore`. Start Module 3 (DataStore) now.

**Next session:** Start `CacheStore` protocol in `BlueskyKit` and `SwiftDataCacheStore` in `BlueskyDataStore`.

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
