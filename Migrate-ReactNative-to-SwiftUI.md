# Migrate React Native to SwiftUI

**Goal:** Full-parity Bluesky client in native SwiftUI targeting iPhone, iPad, and macOS (native SwiftUI, not Catalyst).  
**Approach:** Module-by-module migration. Each module is built, validated, and checked off before the next begins.

See `ModularArchitecture.md` for the Swift architecture principles and `ProjectStructure.md` for the repository layout.

---

## Current React Native App Analysis

### Authentication

- **Protocol:** AT Protocol (atproto) — JWT-based, access token (24h) + refresh token (long-lived)
- **Storage:** Access & refresh JWTs stored in plain text in `AsyncStorage` (single JSON blob keyed `BSKY_STORAGE`)
- **Multi-account:** `accounts[]` array in persisted state; one `currentAccount` active at a time
- **Session restore on launch:** Read last active account → if `accessJwt` expired, call `agent.resumeSession()` with `refreshJwt`; on failure show login
- **2FA:** `AuthFactorTokenRequiredError` triggers a second prompt for TOTP code
- **Self-hosted PDS:** `service` URL and `pdsUrl` stored per account; agent targets the right server
- **Key files:** `Bluesky-ReactNative/src/state/session/`, `src/state/persisted/schema.ts`, `src/screens/Login/`

### Data Storage (three layers)

| Layer | React Native impl | What it stores |
|-------|-------------------|----------------|
| Persisted app state | `AsyncStorage` (single JSON blob) | Session accounts + tokens, language prefs, theme, UI toggles, hidden posts, onboarding state |
| Device/account storage | `MMKV` (encrypted on iOS) | Search history, feed prefs, draft messages, per-account device data |
| Query cache | `MMKV` (per-DID instance) | TanStack Query dehydrated cache — feeds, posts, preferences (persisted per user) |

**Notable:** No SQLite. Pure key-value stores. Tokens are stored in plain text, not in the Keychain.

### Networking

- **Client:** `@atproto/api` — typed XRPC client (`BskyAgent` subclass `BskyAppAgent`)
- **Transport:** HTTPS REST + XRPC (JSON bodies, standard fetch)
- **Auth:** Bearer JWT on every request; auto-refresh on 401 via refresh token
- **Pagination:** Cursor-based (`cursor` param in, `cursor` in response); `useInfiniteQuery` throughout
- **Key endpoint categories:**
  - Feeds: `app.bsky.feed.getFeed`, `getTimeline`, `getAuthorFeed`, `getLikes`
  - Posts: `app.bsky.feed.getPostThread`, `getPosts`; mutations via `com.atproto.repo.applyWrites`
  - Profiles: `app.bsky.actor.getProfile`, `getProfiles`
  - Notifications: `app.bsky.notification.listNotifications`, `updateSeen`
  - Direct Messages: `app.bsky.chat.*` (convo list, messages, send)
  - Moderation: `app.bsky.graph.getMutes`, `getBlocks`, labeler APIs
  - Blobs: `com.atproto.repo.uploadBlob` (images/video)
- **Error handling:** Network errors retry; auth errors log out; typed XRPC errors handled per mutation
- **No WebSocket / real-time:** Pull-based. Push notifications via APNs registered through `app.bsky.notification.registerPush`

### UI / Navigation

- **Shell (native):** `TabView` with 5 tabs — Home, Search, Messages, Notifications, Profile
- **Shell (web):** Single stack + 3-column desktop layout (not relevant for Swift target)
- **Design system (ALF):** 3 themes (light / dark / dim), t-shirt size spacing tokens, responsive breakpoints
- **Components:** Button, Dialog (bottom sheet native), Menu (bottom sheet native), TextField, RichText, Avatar, FeedCard, PostCard, Composer, Lightbox
- **Total screens:** 200+ including feeds, profiles, post threads, DMs, 25+ settings screens, moderation, starter packs, video feed, bookmarks

---

## Swift Module Mapping

| React Native source | Swift module (BlueskyKit) |
|--------------------|--------------------------|
| `src/state/session/` | `BlueskyAuth` — `SessionManager` |
| `src/state/persisted/` | `BlueskyDataStore` — `UserDefaultsPreferencesStore` |
| `src/storage/` | `BlueskyDataStore` — `KeychainAccountStore` |
| `src/state/queries/` | `BlueskyNetworking` (planned) + `BlueskyDataStore` cache |
| `src/Navigation.tsx`, `src/routes.ts` | `Bluesky-SwiftUI` app target — `RootTabView` |
| `src/alf/` | `BlueskyUI` — `Theme`, `Tokens` |
| `src/components/` | `BlueskyUI` — shared components |
| `src/screens/Login/` | `BlueskyAuth` — `LoginView`, `AccountPickerView` |
| `src/screens/*Feed*` | `BlueskyFeed` (future module) |
| `src/view/com/post-thread/` | `BlueskyFeed` (future module) |
| `src/screens/Profile/` | `BlueskyProfile` (future module) |
| `src/screens/Messages/` | `BlueskyMessages` (future module) |
| `src/screens/Notifications/` | `BlueskyNotifications` (future module) |
| `src/screens/Search/` | `BlueskySearch` (future module) |
| `src/view/com/composer/` | `BlueskyComposer` (future module) |
| `src/screens/Moderation*` | `BlueskyModeration` (future module) |
| `src/screens/*Settings*` | `BlueskySettings` (future module) |

---

## Module Migration Checklist

Validate each module end-to-end before starting the next.

### Module 1 — Auth & Session (start here)

**Swift modules:** `BlueskyCore` (Account type), `BlueskyKit` (SessionManaging protocol), `BlueskyAuth` (implementation + views)  
**Goal:** User can log in, tokens are persisted in Keychain, session restores on relaunch, 2FA works, multi-account switching works.

- [x] `Account` struct in `BlueskyCore`: DID, handle, email, service URL, PDS URL
- [x] `SessionManaging` protocol in `BlueskyKit`
- [x] Keychain wrapper in `BlueskyDataStore` for access JWT + refresh JWT per DID
- [x] `SessionManager` (`@Observable`) in `BlueskyAuth`: login, resumeSession, logout, switchAccount, removeAccount
- [x] Login screen: handle/email + password form, service URL field
- [x] 2FA screen: TOTP token prompt on `AuthFactorTokenRequired`
- [x] Account picker: list saved accounts, switch or remove
- [x] Session restore on app launch (check token expiry, refresh if needed)
- [x] Multi-account: store all accounts in Keychain, one `currentAccount` active
- [x] Logout: clear tokens, unregister push token
- [ ] **Validate:** Login → kill app → relaunch → session restored without login prompt

---

### Module 2 — Networking

**Swift module:** `BlueskyNetworking` (new target to add to `Package.swift`)  
**Goal:** Typed XRPC client in Swift covering all endpoints the app uses.

- [x] Add `BlueskyNetworking` target to `BlueskyKit/Package.swift`
- [x] `NetworkClient` protocol in `BlueskyKit`
- [x] `ATProtoClient` with `URLSession` + bearer auth header
- [x] Auto-refresh: intercept 401, use refresh token, retry original request
- [x] Error types in `BlueskyCore`: `ATError` (network, auth, XRPC lexicon errors)
- [x] Cursor pagination type in `BlueskyCore`: `PagedResult<T>`
- [x] Codable lexicon types in `BlueskyCore` for:
  - [x] `app.bsky.feed.*` core types: `PostRecord`, `PostView`, `FeedViewPost`, `FeedReason`, embed hierarchy (`Embed`/`EmbedView` with `$type` discrimination), `BlobRef`
  - [x] `app.bsky.actor.*` core types: `ProfileBasic`, `ProfileView`, `ProfileDetailed`, `Label`, `ListBasic`, `ProfileViewerState`
  - [x] `app.bsky.feed.post` record schema: `RichTextFacet`, `FacetFeature` (mention/link/tag), all embed types
  - [x] `app.bsky.notification.*` (listNotifications, updateSeen, registerPush)
  - [x] `app.bsky.graph.*` (getFollowers, getFollows, getMutes, getBlocks, getLists)
  - [x] `com.atproto.repo.*` (applyWrites, uploadBlob)
  - [x] `chat.bsky.*` (DM convos, messages, send)
  - [x] Moderation lexicons (labeler, report)
- [ ] **Validate:** Unit test each endpoint group against `public.api.bsky.app`

---

### Module 3 — Data Store

**Swift module:** `BlueskyDataStore`  
**Goal:** All persistent state that React Native stored in AsyncStorage/MMKV is replicated in native Swift.

- [x] Storage protocols in `BlueskyKit`: `AccountStore`, `PreferencesStore`, `CacheStore`
  - [x] `AccountStore` (with `nonisolated` requirements — implementations can be actor-isolated)
  - [x] `PreferencesStore` (with `nonisolated` requirements)
  - [x] `CacheStore`
- [x] `KeychainAccountStore` — session tokens, account list
- [x] `UserDefaultsPreferencesStore` — theme, language, UI toggles
- [x] `SwiftDataCacheStore` — query cache per DID (feeds, posts, profiles)
- [x] App group container setup (for notification extension sharing)
- [ ] **Validate:** Preferences survive app restart; cache serves stale content while fresh fetch loads

---

### Module 4 — Design System & Core Components

**Swift module:** `BlueskyUI`  
**Goal:** Shared component library matching the React Native ALF design system.

- [x] `Theme`: light / dark / dim palettes via `@Environment`
- [x] Spacing tokens (2xs → 2xl) as `CGFloat` constants
- [x] Typography scale (`text_xs` → `text_2xl`)
- [x] `PostCard` — avatar, handle, timestamp, body, embed thumbnails, action bar
- [x] `AvatarView` — circular image with fallback initials
- [x] `RichTextView` — render facets (mention, hashtag, URL) as tappable spans via `AttributedString`
- [x] `EmbedView` (`PostEmbedView`) — images, link card, quote post, video thumbnail
- [x] `FeedCard` — feed subscription card
- [x] `ListCard` — curated list card
- [x] Button (`BlueskyButtonStyle`), TextField (`BlueskyTextField`), Divider (`BlueskyDivider`), Badge (`BadgeView`)
- [x] Toast (`ToastView` + `.toast()` modifier)
- [x] Adaptive layout modifiers (`adaptiveNavigation()`)
- [ ] **Validate:** Component gallery / `#Preview` canvas covering all states (needs Xcode + simulator)

---

### Module 5 — Navigation Shell

**Location:** `Bluesky-SwiftUI` app target  
**Goal:** 5-tab app shell that responds to auth state.

- [x] `RootView`: show `LoginView` when no session, `MainTabView` when authenticated
- [x] `TabView` with 5 tabs: Home, Search, Messages, Notifications, Profile
- [x] `NavigationStack` per tab (preserves back stack per tab)
- [x] Badge overlays on Messages and Notifications tabs
- [x] Deep link handler: `bsky://` and `https://bsky.app` URL routing
- [x] Mac: sidebar navigation replacing tab bar; toolbar items
- [x] iPad: split view for sidebar + content column
- [ ] **Validate:** Tabs switch, back navigation works, deep links open correct screen

---

### Module 6 — Home Feed

**Swift module:** `BlueskyFeed` (new)

- [x] Add `BlueskyFeed` target to `BlueskyKit/Package.swift`
- [x] Feed list with infinite scroll (cursor pagination)
- [x] Pull-to-refresh
- [x] Pinned / custom feeds switcher (top tab strip)
- [x] Following feed + algorithmic "Discover" feed
- [x] Post card interactions: like, repost, reply, share, quote, report
- [x] Optimistic like/repost state
- [ ] Filter: hide replies, hide reposts toggles (per feed)
- [ ] `FeedStoring` protocol in `BlueskyKit`: `posts`, `isLoading`, `like/unlike/repost/unrepost` mutations
- [ ] `FeedStore` (`@Observable`) in `BlueskyFeed`: reads `CacheStore` before fetch; writes after success
- [ ] Refactor `FeedViewModel` to observe `any FeedStoring`; zero direct `network.*` calls
- [ ] `BookmarksStoring` protocol + `BookmarksStore`; refactor `BookmarksViewModel`
- [ ] **Validate:** Feed loads, scrolls, interactions persist across refresh

---

### Module 7 — Post Thread

**Swift module:** `BlueskyFeed` (part of same module)

- [x] Thread tree rendering: root post, replies as indented tree
- [ ] Inline post expansion
- [x] Quote post rendering (via `PostEmbedView` in `PostCard`)
- [x] Moderated / blocked post placeholder (`.notFound` / `.blocked` cases in `ThreadView`)
- [ ] Reply composer inline or as sheet
- [ ] `ThreadStoring` protocol + `ThreadStore`; refactor `ThreadViewModel`
- [ ] **Validate:** Full thread renders with correct reply nesting

---

### Module 8 — Profile

**Swift module:** `BlueskyProfile` (new)

- [x] Add `BlueskyProfile` target to `BlueskyKit/Package.swift`
- [x] Profile header: avatar, banner, display name, handle, bio, follower/following counts
- [x] Posts / Replies / Media / Likes tabs (Feeds / Lists deferred)
- [x] Follow / Unfollow / Block / Mute actions (optimistic updates)
- [x] Edit profile sheet (display name + bio; avatar upload deferred to later)
- [ ] Verified badges, labeler badges
- [ ] Known followers chip
- [ ] Feeds / Lists tabs
- [ ] `ProfileStoring` protocol in `BlueskyKit`
- [ ] `ProfileStore` (`@Observable`) in `BlueskyProfile`; reads/writes `CacheStore`
- [ ] Refactor `ProfileViewModel` to observe `any ProfileStoring`; zero direct `network.*` calls
- [ ] **Validate:** Own profile and other profiles, edit flow, follow/unfollow

---

### Module 9 — Search & Discovery

**Swift module:** `BlueskySearch` (new)

- [x] Search bar: actors, posts, feeds
- [ ] Trending topics section
- [x] Suggested follows
- [ ] Hashtag view
- [ ] Topic view
- [ ] `SearchStoring` protocol + `SearchStore`; refactor `SearchViewModel`
- [ ] **Validate:** Search returns results, hashtag opens post list

---

### Module 10 — Notifications

**Swift module:** `BlueskyNotifications` (new)

- [x] Notification list: likes, reposts, follows, mentions, quotes, replies
- [ ] Group notifications (e.g. "3 people liked your post")
- [x] Mark as read / update seen timestamp
- [x] Badge count management
- [ ] Push notification receipt → open correct thread
- [ ] `NotificationsStoring` protocol + `NotificationsStore`; refactor `NotificationsViewModel`
- [ ] **Validate:** Notification list updates, badge clears on open

---

### Module 11 — Direct Messages

**Swift module:** `BlueskyMessages` (new)

- [x] Conversation list
- [x] Message thread view (chat bubbles)
- [x] Send text message
- [ ] Send image attachment
- [ ] Group chat — `chat.bsky.group.*` lexicon types in `BlueskyCore`: `GroupConvo`, `DirectConvo`, `GroupConvoMember`, `DirectConvoMember`, `AddMembersRequest/Response`
- [ ] Group chat — `ConvoWithDetails` discriminated union (group vs. direct) + `parseConvoView` helper; update `MessageThreadViewModel` to carry `ConvoWithDetails` instead of raw `ConvoView`; update `ConvoItem.relatedProfiles` to `[DID: ProfileBasic]` dictionary (was array)
- [ ] Group chat — `ConversationSettingsScreen` with member list (roles: owner/standard), add-members flow, remove-member, edit group name
- [ ] Group chat — Join links: `chat.bsky.group.createJoinLink / editJoinLink / enableJoinLink / disableJoinLink`; `InviteLinkSheet` in `ConversationSettingsScreen`
- [ ] Group chat — Lock/unlock conversation (`chat.bsky.group.lockConversation`)
- [ ] Message requests inbox
- [x] Leave / mute conversation
- [ ] `ConversationStoring` protocol + `ConversationStore`; refactor `MessagesViewModel` + `MessageThreadViewModel`
- [ ] **Validate:** Send and receive messages, group chat create/manage, image attachment works

---

### Module 12 — Composer

**Swift module:** `BlueskyComposer` (new)

- [x] Rich text input with mention autocomplete and hashtag detection
- [x] Image picker + compression + upload (`com.atproto.repo.uploadBlob`)
- [ ] Video picker + upload
- [x] Alt text input per image
- [ ] Link card preview
- [x] Quote post embed
- [x] Language selector
- [ ] Thread / multi-post composer
- [x] Reply context banner
- [x] Character count (300 grapheme limit)
- [ ] Draft persistence
- [ ] `ComposerStoring` protocol + `ComposerStore` (delegates `createRecord` + `uploadBlob` to store); refactor `ComposerViewModel`
- [ ] **Validate:** Post with text, images, mention, link card; reply to thread

---

### Module 13 — Moderation

**Swift module:** `BlueskyModeration` (new)

- [x] Muted accounts list
- [x] Blocked accounts list
- [x] Moderation lists (subscribe / unsubscribe)
- [x] Content label settings (hide/warn/show per label)
- [x] Report dialog (post, profile, list)
- [x] Adult content toggle
- [ ] `ModerationStoring` protocol + `ModerationStore`; refactor `ModerationViewModel`
- [ ] Fix `ReportDialog` (2 direct network calls) to call `ModerationStore` instead
- [ ] **Validate:** Mute/block applies immediately; labeler settings filter content

---

### Module 14 — Settings

**Swift module:** `BlueskySettings` (new)

- [x] Appearance (theme, font size, app icon)
- [x] Language preferences
- [x] Notification preferences (per-type toggles)
- [x] Accessibility settings
- [x] Account settings (email, password, 2FA, app passwords)
- [x] Privacy & security (activity privacy, interaction settings)
- [x] Content & media (autoplay, alt text requirement, external embeds)
- [x] Find contacts flow
- [x] About (version, legal links)
- [ ] `SettingsStoring` protocol + `SettingsStore`; refactor `SettingsViewModel`
- [ ] Fix `FindContactsScreen` (5 direct network calls) to go through `SettingsViewModel` → `SettingsStore`
- [ ] **Validate:** Each setting persists and takes immediate effect

---

### Module 15 — Remaining Screens

- [x] Starter packs (view + create)
- [x] Video feed (TikTok-style vertical scroll)
- [x] Bookmarks
- [x] Feeds management (pin/unpin/reorder)
- [x] Lists (view, create, edit)
- [x] Labeler profile page
- [x] App passwords
- [ ] `ListsStoring` protocol + `ListsStore`; refactor `ListsViewModel` + `ListDetailViewModel`
- [ ] Fix `StarterPackCreateSheet` (1 direct network call) and `StarterPackScreen` (2 calls) to go through `ListsStore`
- [ ] **Validate:** Each screen reaches feature parity with RN app

---

## Validation Protocol (per module)

1. Build succeeds with zero warnings
1.5. ViewModel source files contain zero `network.get(` / `network.post(` / `network.upload(` calls
1.6. Each Feature Store reads from `CacheStore` before its network fetch (stale-while-revalidate)
1.7. Each Feature Store writes to `CacheStore` after a successful network fetch
2. Run on iPhone Simulator (latest iOS)
3. Run on iPad Simulator (verify adaptive layout)
4. Run on macOS (verify sidebar navigation, keyboard/mouse input)
5. Test happy path end-to-end
6. Test error states (network offline, invalid credentials, empty state)
7. Test with a second test account (multi-account)
8. Mark module complete and commit
