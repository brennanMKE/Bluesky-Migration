# Migration Strategy

## Overview

This document describes how to execute the React Native → SwiftUI migration as a series of validated, incremental steps. The detailed per-module checklists live in `Migrate-ReactNative-to-SwiftUI.md`; the Swift package architecture is documented in `ModularArchitecture.md`. This strategy answers the harder question: **how do we keep making forward progress without getting stuck or building on a shaky foundation?**

The core discipline: complete each module to a defined "done" state before starting the next. A partially-built networking layer that breaks auth, or a design system built before the data types are finalized, creates compounding rework. Sequential, validated phases are faster in practice than parallel construction.

---

## Guiding Principles

**The RN app is the spec.** Every behavioral question — what happens on a 401, how grouped notifications render, what the composer character limit enforces — is answered by reading or running `Bluesky-ReactNative`. Don't invent behavior; replicate it, then improve it.

**Validate before advancing.** Each module has an end-to-end validation gate. If the gate isn't passing, the module isn't done. Starting the next module before the current one passes just moves debt forward.

**Protocol-first keeps modules independent.** Define the protocol in `BlueskyKit` (Layer 1) before writing the implementation. This lets feature modules (Layer 3) be designed against the protocol while the implementation is still being built, and makes mocking in tests trivial.

**Stay sequential on features; work in parallel within a module.** Within a single module, tests, implementation, and UI can be worked in parallel. But don't start Module N+1 features while Module N's validation gate is still open.

**Build for all three targets from day one.** iPhone, iPad, and macOS adaptive behaviors are much cheaper to add progressively than to retrofit. Run the simulator for all three at each module gate.

---

## Phases

The 15 modules from `Migrate-ReactNative-to-SwiftUI.md` group into four phases. Each phase ends with a concrete, testable milestone.

---

### Phase 0 — Foundation
**Modules:** 1 (Auth & Session), 2 (Networking), 3 (DataStore)

**Goal:** Invisible infrastructure. No feature screens yet, but the app can authenticate, call every AT Protocol endpoint it will ever need, and persist all state correctly.

**Sequence within phase:**
1. `BlueskyCore` data types (Account, StoredAccount, ATError, PagedResult, all lexicon Codable types)
2. `BlueskyKit` protocols (SessionManaging, AccountStore, PreferencesStore, CacheStore, NetworkClient)
3. `BlueskyDataStore` implementations (KeychainAccountStore, UserDefaultsPreferencesStore, SwiftDataCacheStore)
4. `BlueskyNetworking` — URLSession XRPC client, bearer auth, 401 intercept + retry, all endpoint groups
5. `BlueskyAuth` — SessionManager, login, resumeSession, multi-account, logout
6. Login screen (minimum viable UI to exercise the auth flow)

**Phase milestone:** Log in → kill app → relaunch → session restored. Authenticated API call to `getTimeline` returns data. Preferences survive restart. All module unit tests green.

**Do not proceed to Phase 1 until:** token refresh works correctly end-to-end and all DataStore unit tests pass.

---

### Phase 1 — Skeleton
**Modules:** 4 (Design System & Core Components), 5 (Navigation Shell)

**Goal:** A navigable app shell. No real content yet, but the structure a user would recognize is in place.

**Sequence within phase:**
1. `BlueskyUI` design tokens: Theme (light/dark/dim), spacing, typography
2. `BlueskyUI` foundational components: Button, TextField, Avatar, Divider, Badge, Toast
3. `BlueskyUI` content components: PostCard, RichTextView, EmbedView, FeedCard, ListCard
4. `#Preview` component gallery covering all component states
5. `RootView` auth gate (LoginView ↔ MainTabView)
6. 5-tab `TabView` with `NavigationStack` per tab
7. Deep link handler (`bsky://` and `https://bsky.app`)
8. iPad split view + macOS sidebar

**Phase milestone:** App launches, tabs switch, back navigation works, deep links route to the correct (placeholder) screen, component gallery renders all states on iPhone/iPad/Mac.

---

### Phase 2 — Core Reading Experience
**Modules:** 6 (Home Feed), 7 (Post Thread), 8 (Profile)

**Goal:** The app is dogfoodable for reading. A developer can use it as their daily Bluesky reader.

**Sequence within phase:**
1. `BlueskyFeed` target in `Package.swift`
2. Feed list with infinite scroll and pull-to-refresh
3. Pinned/custom feed switcher
4. Post interactions (like, repost, reply, share) with optimistic state
5. Thread tree rendering with quote posts and moderated placeholders
6. Reply composer (sheet)
7. `BlueskyProfile` target in `Package.swift`
8. Profile header, tab bar (Posts/Replies/Media/Likes/Feeds/Lists)
9. Follow/unfollow/block/mute actions
10. Edit profile sheet with avatar upload

**Phase milestone:** Browse timeline → open a thread → view a profile → follow someone → edit own profile. All interactions persist across refresh. First internal TestFlight build.

---

### Phase 3 — Engagement
**Modules:** 9 (Search), 10 (Notifications), 11 (Direct Messages), 12 (Composer)

**Goal:** A fully interactive app. Users can create content and participate in the network.

**Sequence within phase:**
1. `BlueskySearch` — search bar, actors/posts/feeds results, trending, hashtag/topic views
2. `BlueskyNotifications` — notification list, grouping, mark-as-read, badge management, push → screen routing
3. `BlueskyMessages` — conversation list, thread view, send text, send image, message requests, group settings
4. `BlueskyComposer` — rich text input, mention autocomplete, image/video picker + upload, alt text, link card, quote embed, thread composer, draft persistence

**Phase milestone:** Full write/reply/DM flow works end-to-end. Push notifications arrive and route correctly. Draft survives backgrounding. Wider TestFlight beta.

---

### Phase 4 — Completeness
**Modules:** 13 (Moderation), 14 (Settings), 15 (Remaining Screens)

**Goal:** Feature parity with the React Native app. Ready for App Store submission.

**Sequence within phase:**
1. `BlueskyModeration` — mutes, blocks, moderation lists, content label settings, report dialog, adult content toggle
2. `BlueskySettings` — appearance, language, notifications, accessibility, account, privacy, content/media, about
3. Remaining screens: starter packs, video feed, bookmarks, feeds management, lists, labeler profile, app passwords

**Phase milestone:** Every screen in the RN app has a SwiftUI equivalent that passes the validation protocol from `Migrate-ReactNative-to-SwiftUI.md`. Zero known regressions. Submitted to App Store review.

---

## Working Rhythm

**Definition of "done" for a checklist item:** the item works on all three simulators (iPhone, iPad, macOS), the happy path is tested, at least one error state is tested, and it works correctly with a second test account.

**Commit cadence:** Commit at each completed checklist item, not at each file save. The commit message names the module and item: `BlueskyAuth: session restore on relaunch`. This makes it easy to bisect regressions.

**Using the RN app as reference:** When behavior is ambiguous, open the RN app on a simulator and run the scenario. Screen-record if useful. Don't guess.

**Zero-warning policy:** Each module compiles with zero warnings before its validation gate is marked passed. Swift 6 strict concurrency warnings are treated as errors.

**Test discipline:**
- `BlueskyCore`: pure unit tests (encode/decode fixture JSON)
- `BlueskyNetworking`: integration tests against `public.api.bsky.app` for unauthenticated endpoints; mocked for auth-gated ones
- `BlueskyDataStore`: unit tests using in-memory implementations
- `BlueskyAuth`: unit tests with `MockNetworkClient` + `MockAccountStore`
- Feature modules: unit tests with mocked dependencies; `#Preview` for visual validation

---

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Token refresh loop (401 on the refresh call itself logs out incorrectly) | High | High | Implement and unit-test the retry logic with a mock that simulates each failure mode before any real API calls |
| XRPC lexicon gaps (endpoint added to RN app that isn't in the Swift types) | High | Medium | Encode every endpoint the RN app uses in `BlueskyCore` types at the start of Phase 0; add a test fixture per endpoint group |
| Rich text `AttributedString` edge cases (overlapping facets, emoji grapheme clusters) | Medium | Medium | Port the RN app's rich text test fixtures to Swift unit tests in `BlueskyCore` |
| Keychain multi-account concurrency (two simultaneous token refreshes for different DIDs) | Low | High | `KeychainAccountStore` operations are `actor`-isolated; test with two logged-in accounts and background refresh |
| Swift 6 `@MainActor` propagation causing unexpected build failures in new modules | High | Low | Set `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` in the xcconfig (already done); address violations as they appear, not retroactively |
| macOS / iPad layout debt accumulating | Medium | Medium | Run all three simulators at each module gate, not only at the end of a phase |
| Scope creep into RN app parity edge cases too early | Medium | Medium | Stay in phase order; log any "nice to have" observations as GitHub issues, don't implement until Phase 4 |

---

## Deferred Decisions

These don't need to be resolved now but must be decided before the module that depends on them begins.

| Decision | Needed by | Options |
|----------|-----------|---------|
| Cache store backend: SwiftData vs SQLite | Module 3 | SwiftData is simpler; SQLite (via GRDB or swift-sqlite) is more predictable under concurrency. Decide after reviewing Swift 6 SwiftData actor-isolation behavior. |
| Networking: pure URLSession vs third-party HTTP lib | Module 2 | Pure URLSession keeps the dependency tree minimal and is sufficient for XRPC. Third-party (e.g. Alamofire) adds retry/interceptor sugar but at the cost of a heavy dependency. Current recommendation: URLSession. |
| TestFlight beta track structure | Phase 2 milestone | Internal only through Phase 2; external beta at Phase 3 milestone. |
| App group identifier for notification extension | Module 10 | Must match the bundle ID prefix in `Build.xcconfig` (`co.sstools.Bluesky`). Decide the group ID before push notification work begins. |
| Video playback library | Module 15 | AVPlayer is sufficient for the vertical video feed; no third-party lib needed. |

---

## Success Criteria

The migration is complete when all of the following are true:

1. Every screen and interaction listed in `Migrate-ReactNative-to-SwiftUI.md` has a SwiftUI implementation that passes its validation gate.
2. The app builds and runs on iPhone, iPad, and macOS with zero warnings.
3. All unit and integration tests pass in CI.
4. A second test account can log in, switch accounts, and operate independently from the first.
5. The app has been submitted to and approved by App Store review.
6. The React Native app is no longer the primary reference — the SwiftUI app is the shipping product.
