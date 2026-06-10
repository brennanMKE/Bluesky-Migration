# Port Completion Report

**Date:** 2026-06-10
**Scope:** What remains to bring the SwiftUI port (`../Bluesky-SwiftUI` + `../BlueskyKit`) to completion against the React Native reference (`../Bluesky-ReactNative`).

---

## Executive summary

The port is **feature-complete or nearly so at the implementation level**. All 15 modules from `Migrate-ReactNative-to-SwiftUI.md` have shipped code, 150+ filed issues have been resolved (including major parity passes on feeds, notifications, profile, messages, composer, settings, moderation, lists, signup/onboarding, and recovery flows), and the upstream RN repo has **zero new commits past the recorded baseline** (`46b8a58`, verified today) — there is no drift to absorb.

What remains falls into five buckets, roughly in order of effort:

1. **Manual validation** — 7 open module gates (4 macOS, 3 iOS) and 12 sign-off parity test plans (~130 unchecked checklist items). This is the bulk of remaining work and is testing, not coding.
2. **UI test automation** — 9 open issues (#0175–#0183). Accessibility identifiers are already committed in BlueskyKit; the harness and test suites are not yet written.
3. **A small amount of feature/polish code** — push-notification routing (#0030, externally blocked), color-palette asset-catalog migration (#0040), and a tab-bar polish item (#0156, blocked on a clarification).
4. **Architecture cleanup** — ~15 screens/view models still make direct `network.*` calls, contradicting the store-pattern gate recorded as passed in `Progress.md`.
5. **Tracking-doc hygiene** — `Issues.md`, `Progress.md`, and `Migrate-ReactNative-to-SwiftUI.md` have drifted badly from the actual state of the code and the issue files. This makes the project look less finished than it is.

There are **27 truly unresolved issues** (per the issue files themselves; the index overstates this — see §6).

---

## 1. Open validation gates (manual testing, no code expected)

These are the per-module "Validate:" gates. All implementations exist and build; each gate is a live-account test session.

### macOS gates

| Issue | Gate | Remaining checks |
|-------|------|------------------|
| [0031](issues/0031.md) | Module 10 — Notifications | 3: list updates with new activity, badge clears on view, pull-to-refresh. Former blockers #0062/#0063 are resolved. |
| [0035](issues/0035.md) | Module 12 — Composer | 5: plain-text post, image post via Add Image, mention autocomplete, draft clears after post, reply-draft scoping. Code blockers already fixed (BlueskyKit `c826300`). |
| [0037](issues/0037.md) | Module 14 — Settings persistence | 6: system appearance, font size, notification toggles, content/media toggles, accessibility toggles, languages — each must survive relaunch. |
| [0038](issues/0038.md) | Module 15 — Remaining screens | 7 scenarios: Lists, Starter Packs, Saved Feeds, Video Feed, Labeler Profile, App Passwords, Bookmarks. |

### iOS gates

| Issue | Gate | Remaining checks |
|-------|------|------------------|
| [0064](issues/0064.md) | Module 12 — Composer on iPhone | 10: PHPicker images + alt text, video post, mentions, link card, thread composer, drafts, keyboard/safe-area. |
| [0065](issues/0065.md) | Module 14 — Settings on iPhone | 7: appearance, font size, notifications, content, languages, haptics, in-app browser. |
| [0066](issues/0066.md) | Module 15 — Remaining screens on iPhone | 9: iOS-native behaviors (swipe gestures, drag-reorder, share sheet, swipe-to-delete). Video Feed flagged highest-risk (full-screen vertical auto-play, background/foreground resume). |

**Note:** the iOS gates were filed as blocked on #0061 (iOS build failure), which is now **resolved** — these three gates are unblocked and runnable today.

## 2. Sign-off parity passes (#0161–#0172)

Twelve structured test plans comparing the SwiftUI app side-by-side against the RN client, one per surface. All are open with **every checklist item unchecked** (~130 items total):

| Issue | Surface | Items |
|-------|---------|-------|
| [0161](issues/0161.md) | Authentication & session (incl. 2FA, multi-account, token refresh) | 10 |
| [0162](issues/0162.md) | Home feed (selector, filters, interactions, navigation) | 11 |
| [0163](issues/0163.md) | Thread view & post actions (focal emphasis, sort, threadgate, video) | 10 |
| [0164](issues/0164.md) | Profile (own & others, edit, follow/block/mute/report, badges) | 9 |
| [0165](issues/0165.md) | Search & discovery (typeahead, tabs, hashtags, trending) | 10 |
| [0166](issues/0166.md) | Notifications (20 reason types, grouping, routing, badge lifecycle) | 10 |
| [0167](issues/0167.md) | Direct messages (incl. group chat, reactions, requests inbox) | 14 |
| [0168](issues/0168.md) | Composer (counter, facets, media, drafts, threading, quotes) | 12 |
| [0169](issues/0169.md) | Settings (all 11 RN sections, persistence, sign-out) | 13 |
| [0170](issues/0170.md) | Moderation (mutes/blocks, labelers, report flow, interaction settings) | 10 |
| [0171](issues/0171.md) | Lists, Starter Packs & Bookmarks | 14 |
| [0172](issues/0172.md) | Navigation shell & deep links (tabs/sidebar, cold/warm launch, bad URLs) | 10 |

These supersede the module gates in coverage; a reasonable strategy is to fold the §1 gate checks into the corresponding sign-off run rather than doing both separately. The UI test suites in §3 can automate a meaningful slice of these checklists before the manual passes begin.

## 3. UI test automation (#0175–#0183)

All nine issues are open. Current state of the code:

- **Done:** accessibility identifiers for search, notifications, DMs, composer, settings, and moderation screens are committed in BlueskyKit (`45c7e08`…`e592da9`).
- **Not started:** the `Bluesky-SwiftUIUITests` target contains only the Xcode template files. No `UITestNavigator`, no `BLUESKY_UI_TEST_SCRIPT` handling, no screenshot harness exists anywhere in either repo.

Dependency order:

1. **#0175 — foundation** (everything else depends on it): launch-arg/JSON navigation driver, `BlueskyUITestHarness` (launch/screenshot/wait helpers), authenticated test session via `BLUESKY_TEST_HANDLE`/`BLUESKY_TEST_PASSWORD`.
2. **#0176–#0183 — per-surface suites**: home feed, thread view, profile, search, notifications, DMs, composer, settings/moderation. Each specifies its accessibility identifiers, light/dark screenshot passes, and determinism notes (e.g. `BLUESKY_TEST_POST_URI` for a stable thread, never posting against production — use a test PDS or exclude `@network-write` tests from default runs).

## 4. Remaining feature / polish code

| Issue | Work | Blocker |
|-------|------|---------|
| [0030](issues/0030.md) | Push notification receipt → open correct thread. Needs APNs entitlement, device-token registration, payload parsing. | **External:** Apple Developer provisioning, and an unresolved question of whether Bluesky's push gateway accepts third-party bundle IDs at all. May need to be descoped or marked `wontfix` if the gateway won't serve this client. |
| [0040](issues/0040.md) | Color palette: migrate `Theme.swift` hand-rolled hex values to asset-catalog Color Sets sourced from the authoritative ALF token values (`@bsky.app/alf`); delete the `dim` variant. The issue body contains an 8-step implementation plan. | None — ready to implement. |
| [0156](issues/0156.md) | iPhone tab-bar avatar selected-state ring / spacing. Investigation found the described custom tab bar **does not exist on `main`** — #0071 (iOS bottom chrome redesign) was marked resolved citing commit hashes that don't exist. | **Needs a decision:** does the #0071 redesign live on an unmerged branch, should it be re-done, or is it obsolete? #0156 can't be fixed against code that doesn't ship. |

## 5. Architecture cleanup — store-pattern stragglers

`Progress.md` records the store-layer prerequisite as complete, including the gate "grep for direct network calls returns zero results." Running the equivalent grep today returns **169 matches**. Most are legitimate (20 `*Store.swift` files own the `NetworkClient` by design), but roughly **15 screens/view models still call the network directly**, including:

`ThreadViewModel`, `FeedView`, `ListDetailScreen`, `HashtagView`, `LikedByScreen`, `RepostedByScreen`, `QuotesOfScreen`, `ThreadPreferencesScreen`, `FollowingFeedPreferencesScreen`, `PostInteractionSettingsScreen`, `PrivacySettingsScreen`, `ActivityPrivacySettingsScreen`, `LanguageSettingsScreen`, `MutedWordsScreen`, `AccountSettingsScreen`.

These were mostly added after the store rollout (the preference/settings screens and the liked-by/reposted-by/quotes screens came from later issues) and never got stores. To honor the architecture decision recorded in `Progress.md` ("ViewModels … contain no `NetworkClient` reference — this is the required architecture for all modules"), each needs its calls routed through the appropriate store. This is mechanical work, not redesign.

## 6. Tracking-document drift (housekeeping)

The planning docs materially misrepresent the project state and should be reconciled before (or during) the sign-off phase:

- **`Issues.md` index vs. issue files:**
  - ~45 issue files are missing from the index entirely (0061–0062, 0064–0104, 0119, 0123, 0129–0133, 0136–0137, 0141, 0156, 0158, 0160). Almost all of them are resolved — the index hides a lot of finished work.
  - Several index rows show stale statuses: 0032, 0033, 0034, 0041, 0042, 0046, 0052–0055, 0058–0060 are **resolved** in their files but listed as open/in-progress; 0030 and 0031 are open, not in-progress.
  - Many issue files use status `closed`, which isn't one of the four documented values (`open · in-progress · resolved · wontfix`).
  - Issue `0157` does not exist (numbering gap; 0156 and 0158 both exist).
- **`Progress.md` Current Status** still says "Phase 0 — Foundation / Module 15" — in reality all modules are implemented and the project is in a validation/sign-off phase. The Up Next section also predates ~120 resolved issues of parity work.
- **`Migrate-ReactNative-to-SwiftUI.md`** has dozens of unchecked boxes for work that is demonstrably done (group chat, feed filters, reply composer, inline expansion, profile badges/known-followers/Feeds+Lists tabs, trending, hashtag views, grouped notifications, image attachments, message requests, video picker, link cards, drafts, the entire store layer). The checkboxes were never ticked when the matching issues were resolved.
- **`BlueskyOnboarding`** exists as a 16th module in `BlueskyKit/Sources` (from the signup/onboarding issues #0091–#0095) but appears in none of the planning docs' module lists.

## Suggested completion order

1. **Doc reconciliation** (§6) — cheap, and makes every subsequent status check trustworthy.
2. **Store-pattern cleanup** (§5) — do it before sign-offs so validation runs against the final architecture.
3. **#0040 palette migration** (§4) — visual change; land it before screenshot-based testing so screenshots don't all need re-capture.
4. **Resolve the #0071/#0156 question and the #0030 gateway question** (§4) — both need decisions, not just code.
5. **#0175 UI test foundation, then #0176–#0183 suites** (§3) — automation pays for itself during the sign-off passes.
6. **Module gates** (§1) — macOS first (no blockers), then iOS (now unblocked by #0061's resolution).
7. **Sign-off parity passes #0161–#0172** (§2) — the final acceptance step for the port.

## What is *not* needed

- **No RN drift absorbed yet, but upstream has moved:** the local `../Bluesky-ReactNative` checkout sits exactly at the recorded baseline (`46b8a58`), so `git log 46b8a58..HEAD` shows zero commits — however, a `git fetch` on 2026-06-10 shows `origin/main` is **370 commits ahead** of the baseline. Per the session-start protocol, review that diff deliberately before advancing the baseline; don't pull it casually into the reference checkout.
- **No missing modules:** every module in the migration spec has a built target in `BlueskyKit` plus the app shell, and every screen-level parity issue filed to date (other than the items in §4) is resolved.
- **No outstanding build breaks:** both repos build; the iOS build failure (#0061) is resolved.
