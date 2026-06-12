# Issues

Lightweight issue tracking for bugs and regressions found while testing the Bluesky SwiftUI app.

Issues are described verbally (or with screenshots) and recorded here so work is not interrupted. Each issue gets a unique four-digit number, left-padded with zeros (`0001`, `0002`, …).

Issue **tracking** lives in this repo (`Bluesky-Migration`); the **code** lives in two sibling repos, `../Bluesky-SwiftUI/` (app target — always open via `Bluesky.xcworkspace`) and `../BlueskyKit/` (library modules). That split shapes the workflow below:

- Issue markdown (`Issues.md`, `issues/NNNN.md`, attachments) commits directly to this repo's `main` — this repo never branches.
- Code changes for an issue happen on an `issue/NNNN` branch in whichever code repo(s) the fix touches, and land on that repo's `main` as a single squash commit after an independent review approves the diff.
- After the squash merge the issue branch is **kept, not deleted** — the branch and its commits remain unchanged as the full history of the work, while `main` stays clean with one `#NNNN` commit per issue.

---

## Status values

| File value | Display name | Meaning |
|---|---|---|
| `open` | Open | Filed but not yet started |
| `in-progress` | In Progress | Actively being worked on |
| `resolved` | Resolved | Work passed the review gate and landed; awaiting user confirmation |
| `closed` | Closed | User has confirmed the fix |
| `wontfix` | Won't Fix | Acknowledged but won't be addressed |

Use the **file value** (lowercase, hyphenated) in the issue's metadata table and the Index below.

> Legacy note: issues resolved before this review-gated workflow was adopted (2026-06-11) carry `resolved` under the old rule (user-confirmed resolution) and were not migrated to `closed`. The `resolved` / `closed` distinction applies from this date forward.

## Critical rule: never close without explicit confirmation

An issue must **never** be marked `closed` or `wontfix` based on inference. Only when the user has said so in plain language. Do not infer resolution from:

- a code change you (or a subagent) just made
- a commit message
- the filing of a related issue
- the user saying "thanks, that looks better"

The deliberate exception: an issue may be set to `resolved` (work-is-done-but-not-confirmed) when the work has passed this project's review gate — see "Working an issue" below. That transition is made by the orchestrator after the reviewer approves, never by the implementer subagent itself. Nothing and nobody but the user sets `closed`. This separation is the entire reason `resolved` and `closed` are different states. When in doubt, ask.

---

## Index

| # | Title | Module | Platform | Status |
|---|-------|--------|----------|--------|
| [0001](issues/0001.md) | Account session not persisted across app launches | BlueskyDataStore | macOS | resolved |
| [0002](issues/0002.md) | Home feed posts not loaded after sign-in | BlueskyFeed | All | resolved |
| [0003](issues/0003.md) | Feed list ignores Dark Mode — white background with black text | BlueskyFeed | macOS | resolved |
| [0004](issues/0004.md) | Reply button not functional on post cells | BlueskyFeed | All | resolved |
| [0005](issues/0005.md) | Repost button not functional on post cells | BlueskyFeed | All | resolved |
| [0006](issues/0006.md) | Like/Reaction button not functional on post cells | BlueskyFeed | All | resolved |
| [0007](issues/0007.md) | Share button not functional on post cells | BlueskyFeed | All | resolved |
| [0008](issues/0008.md) | Bookmark button missing from post action bar | BlueskyFeed | All | resolved |
| [0009](issues/0009.md) | Post action buttons lack tooltips on macOS | BlueskyFeed | macOS | resolved |
| [0010](issues/0010.md) | `getFeed` XRPC call missing required `feed` query parameter | BlueskyFeed | All | resolved |
| [0011](issues/0011.md) | Module 1 gate: session restore not validated | BlueskyAuth / BlueskyDataStore | All | resolved |
| [0012](issues/0012.md) | Module 2 gate: networking endpoint groups not live-tested | BlueskyNetworking / BlueskyCore | All | resolved |
| [0013](issues/0013.md) | Module 3 gate: preferences persistence and cache stale-while-revalidate not validated | BlueskyDataStore | All | resolved |
| [0014](issues/0014.md) | Module 4: #Preview canvas not validated in Xcode | BlueskyUI | All | resolved |
| [0015](issues/0015.md) | Module 4 gate: component gallery not validated | BlueskyUI | All | resolved |
| [0016](issues/0016.md) | Module 5 gate: navigation shell not validated (tabs, back nav, deep links) | Bluesky-SwiftUI | All | resolved |
| [0017](issues/0017.md) | Module 6 feature: feed filter toggles (hide replies / hide reposts) not implemented | BlueskyFeed | All | resolved |
| [0018](issues/0018.md) | Module 6 gate: home feed live validation | BlueskyFeed | All | resolved |
| [0019](issues/0019.md) | Module 7 feature: reply composer not implemented | BlueskyFeed | All | resolved |
| [0020](issues/0020.md) | Module 7 feature: inline post expansion not implemented | BlueskyFeed | All | resolved |
| [0021](issues/0021.md) | Module 7 gate: thread view live validation | BlueskyFeed | All | resolved |
| [0022](issues/0022.md) | Module 8 feature: profile Feeds and Lists tabs not implemented | BlueskyProfile | All | resolved |
| [0023](issues/0023.md) | Module 8 feature: verified badges and labeler badges not shown on profiles | BlueskyProfile | All | resolved |
| [0024](issues/0024.md) | Module 8 feature: known followers chip not shown on profiles | BlueskyProfile | All | resolved |
| [0025](issues/0025.md) | Module 8 gate: profile live validation | BlueskyProfile | All | resolved |
| [0026](issues/0026.md) | Module 9 feature: trending topics section not implemented | BlueskySearch | All | resolved |
| [0027](issues/0027.md) | Module 9 feature: hashtag and topic views not implemented | BlueskySearch | All | resolved |
| [0028](issues/0028.md) | Module 9 gate: search live validation | BlueskySearch | All | resolved |
| [0029](issues/0029.md) | Module 10 feature: grouped notifications not implemented | BlueskyNotifications | All | resolved |
| [0030](issues/0030.md) | Module 10 feature: push notification receipt does not open the correct thread | BlueskyNotifications | iOS | in-progress |
| [0031](issues/0031.md) | Module 10 gate: notifications live validation | BlueskyNotifications | All | in-progress |
| [0032](issues/0032.md) | Module 11 feature: image attachments and message requests inbox not implemented | BlueskyMessages | All | in-progress |
| [0033](issues/0033.md) | Module 11 gate: DM and group chat live validation | BlueskyMessages | All | in-progress |
| [0034](issues/0034.md) | Module 12 feature: video picker, link card preview, thread composer, draft persistence not implemented | BlueskyComposer | All | in-progress |
| [0035](issues/0035.md) | Module 12 gate: composer live validation | BlueskyComposer | All | in-progress |
| [0036](issues/0036.md) | Module 13 gate: moderation live validation | BlueskyModeration | All | resolved |
| [0037](issues/0037.md) | Module 14 gate: settings persistence live validation | BlueskySettings | All | in-progress |
| [0038](issues/0038.md) | Module 15 gate: remaining screens feature parity validation | BlueskyLists / BlueskyFeed / BlueskyModeration / BlueskySettings | All | in-progress |
| [0039](issues/0039.md) | Tapping a post navigates to a blank screen | BlueskyFeed | All | resolved |
| [0040](issues/0040.md) | Design refinement: revisit app color palette | BlueskyUI | All | in-progress |
| [0041](issues/0041.md) | Action button state may be stale when toggled | BlueskyFeed | All | in-progress |
| [0042](issues/0042.md) | Toolbar list button is centered instead of right-aligned | BlueskyFeed | macOS | in-progress |
| [0043](issues/0043.md) | Pull-to-refresh not implemented for feeds, replies, and search | BlueskyFeed / BlueskyProfile / BlueskySearch | All | resolved |
| [0044](issues/0044.md) | Feed fails to load: missing `$type` in embedded quote record | BlueskyCore | All | resolved |
| [0045](issues/0045.md) | Thread view styling is broken: collapsed rows, connector lines, dark mode failure | BlueskyFeed | All | resolved |
| [0046](issues/0046.md) | Tapping a post author avatar does not navigate to their profile | BlueskyFeed / BlueskyProfile | All | open |
| [0047](issues/0047.md) | Ellipsis (…) context menu missing from post action bar | BlueskyFeed / BlueskyUI | All | resolved |
| [0048](issues/0048.md) | Feed cache not used: no stale content shown when offline | BlueskyFeed / BlueskyDataStore | All | resolved |
| [0049](issues/0049.md) | FeedView task fires twice on launch, creating duplicate FeedViewModels | BlueskyFeed | All | resolved |
| [0050](issues/0050.md) | Add Light and Dark #Preview blocks to all views missing them | All | All | resolved |
| [0051](issues/0051.md) | Search results post cards have white background in dark mode | BlueskySearch | All | resolved |
| [0052](issues/0052.md) | Deep link opens a new window instead of routing in the existing window | Bluesky-SwiftUI | macOS | in-progress |
| [0053](issues/0053.md) | Like state does not persist after tapping the like button | BlueskyFeed | All | in-progress |
| [0054](issues/0054.md) | Cannot tap a reply in thread view to navigate into it | BlueskyFeed | All | in-progress |
| [0055](issues/0055.md) | Switching tabs while in a thread does not change the active tab | Bluesky-SwiftUI | macOS | in-progress |
| [0056](issues/0056.md) | Profile screen missing banner, avatar placeholder broken, post cards not dark mode | BlueskyProfile | All | resolved |
| [0057](issues/0057.md) | Bookmarks not implemented: requires server-side or local storage solution | BlueskyFeed / BlueskyDataStore | All | resolved |
| [0058](issues/0058.md) | Audit and eliminate `try?` to prevent silent failures | All | All | open |
| [0059](issues/0059.md) | Network reachability gating using Network framework | BlueskyNetworking / BlueskyKit | All | open |
| [0060](issues/0060.md) | Saved Posts section does not match Bluesky website UX | BlueskyFeed / Bluesky-SwiftUI | All | open |
| [0063](issues/0063.md) | Notification reason labels incomplete (`subscribed-post` and others render verbatim) | BlueskyNotifications | All | resolved |
| [0105](issues/0105.md) | Group chat thread bubbles missing sender info row | BlueskyMessages | All | resolved |
| [0106](issues/0106.md) | Message bubbles have no per-message context menu | BlueskyMessages | All | resolved |
| [0107](issues/0107.md) | Message thread missing per-message timestamps and date dividers | BlueskyMessages | All | resolved |
| [0108](issues/0108.md) | Message thread doesn't render link cards or post embeds inside bubbles | BlueskyMessages | All | resolved |
| [0109](issues/0109.md) | Message thread has no scroll-to-bottom button or new-messages divider | BlueskyMessages | All | resolved |
| [0110](issues/0110.md) | Message reactions (emoji) are not implemented | BlueskyMessages | All | resolved |
| [0111](issues/0111.md) | Message thread doesn't render system messages (e.g. "@alice added @bob") | BlueskyMessages | All | resolved |
| [0112](issues/0112.md) | Compose bar in DMs doesn't detect mentions, links, or hashtags (no facets) | BlueskyMessages | All | resolved |
| [0113](issues/0113.md) | Account settings is a stub; needs full implementation (email, password, handle, birthday, deactivate, export) | BlueskySettings | All | resolved |
| [0114](issues/0114.md) | Privacy & Security settings missing inline 2FA toggle, app-passwords link with badge, and PWI opt-out | BlueskySettings | All | resolved |
| [0115](issues/0115.md) | Notification settings missing per-type sub-screens, push permission UI, and email toggles | BlueskySettings | iOS / All | resolved |
| [0116](issues/0116.md) | Thread Preferences screen is missing (sort order, group replies) | BlueskySettings | All | resolved |
| [0117](issues/0117.md) | Following Feed Preferences screen is missing (hide replies / reposts / quotes) | BlueskySettings / BlueskyFeed | All | resolved |
| [0118](issues/0118.md) | External Media Preferences screen is missing (per-source toggles for YouTube, Spotify, etc.) | BlueskySettings | All | resolved |
| [0120](issues/0120.md) | Language settings missing app language and content-language multi-select | BlueskySettings | All | resolved |
| [0121](issues/0121.md) | Accessibility settings missing larger-alt-badge toggle and haptic feedback toggle | BlueskySettings | iOS / All | resolved |
| [0122](issues/0122.md) | Activity Privacy settings screen is missing | BlueskySettings | All | resolved |
| [0124](issues/0124.md) | About screen missing system-info section, status link, and dev-mode tools | BlueskySettings | All | resolved |
| [0125](issues/0125.md) | List detail screen missing header (avatar, name, description, creator, action buttons) | BlueskyLists | All | resolved |
| [0126](issues/0126.md) | List detail screen missing the "About" tab | BlueskyLists | All | resolved |
| [0127](issues/0127.md) | Lists have no edit or delete UI | BlueskyLists | All | resolved |
| [0128](issues/0128.md) | Starter Pack create is a single sheet; RN uses a multi-step wizard | BlueskyLists | All | resolved |
| [0134](issues/0134.md) | Mutes / Blocks lists have no search field | BlueskyModeration | All | resolved |
| [0135](issues/0135.md) | Report dialog uses flat reasons; needs categorized picker + labeler selection | BlueskyModeration | All | resolved |
| [0138](issues/0138.md) | Post Interaction Settings screen tree is missing (default reply / quote / DM rules) | BlueskyModeration | All | resolved |
| [0139](issues/0139.md) | Liked-by, Reposted-by, and Quotes-of screens are missing | BlueskyFeed / BlueskyProfile | All | resolved |
| [0140](issues/0140.md) | Thread view has no reply-sort dropdown | BlueskyFeed | All | resolved |
| [0142](issues/0142.md) | Posts have no "Show more" / "Show less" expansion for long text | BlueskyFeed / BlueskyUI | All | resolved |
| [0143](issues/0143.md) | Posts have no Translate option in the menu | BlueskyFeed / BlueskyUI | iOS / All | resolved |
| [0144](issues/0144.md) | Post menu missing "Copy link to post" and "Open in browser" | BlueskyFeed / BlueskyUI | All | resolved |
| [0145](issues/0145.md) | Thread view doesn't honor or display threadgate-hidden replies | BlueskyFeed | All | resolved |
| [0146](issues/0146.md) | Focal post in thread view has no visual emphasis (larger avatar, larger text, full date, expanded stats) | BlueskyFeed / BlueskyUI | All | resolved |
| [0147](issues/0147.md) | Video embeds render as a thumbnail; need inline / fullscreen player | BlueskyUI / BlueskyFeed | All | resolved |
| [0148](issues/0148.md) | macOS top-right toolbar shows three icons crammed in a single capsule | Bluesky-SwiftUI / BlueskyUI | macOS | resolved |
| [0149](issues/0149.md) | Raw rkey leaks into a feed/list row ("77a502dfc060" rendered as text) | BlueskyFeed / BlueskyUI | macOS | resolved |
| [0150](issues/0150.md) | Sidebar drawer parity with React Native: profile header, full nav rows, footer legal links | Bluesky-SwiftUI | iOS / macOS | resolved |
| [0151](issues/0151.md) | Composer opens with stale text pre-filled when no draft was resumed | BlueskyComposer | All | resolved |
| [0152](issues/0152.md) | Bookmarks fail to load: Codable decoding error on `bookmarks[0].uri` | BlueskyCore / BlueskyFeed | All | resolved |
| [0153](issues/0153.md) | App icon asset catalog is empty; populate from `AppIcon.png` for iOS / iPadOS / macOS | Bluesky-SwiftUI | All | resolved |
| [0154](issues/0154.md) | Bookmarks decoding still fails: `bookmarks[*].item` is a discriminated union, not a plain PostView | BlueskyCore / BlueskyFeed | All | resolved |
| [0155](issues/0155.md) | Profile content clipped on the leading edge (regression of #0089) | BlueskyProfile | iOS | resolved |
| [0159](issues/0159.md) | Profile screen reached from a notification: like / repost / bookmark / share buttons are unresponsive on the post rows | BlueskyProfile / BlueskyFeed / Bluesky-SwiftUI | All | resolved |
| [0161](issues/0161.md) | Sign-off: Authentication & session parity (RN) | BlueskyAuth | All | open |
| [0162](issues/0162.md) | Sign-off: Home feed parity (RN) | BlueskyFeed | All | open |
| [0163](issues/0163.md) | Sign-off: Thread view & post action parity (RN) | BlueskyFeed | All | open |
| [0164](issues/0164.md) | Sign-off: Profile parity (own & others) | BlueskyProfile | All | open |
| [0165](issues/0165.md) | Sign-off: Search & discovery parity (RN) | BlueskySearch | All | open |
| [0166](issues/0166.md) | Sign-off: Notifications parity (RN) | BlueskyNotifications | All | open |
| [0167](issues/0167.md) | Sign-off: Direct messages parity (RN) | BlueskyMessages | All | open |
| [0168](issues/0168.md) | Sign-off: Composer parity (RN) | BlueskyComposer | All | open |
| [0169](issues/0169.md) | Sign-off: Settings parity (RN) | BlueskySettings | All | open |
| [0170](issues/0170.md) | Sign-off: Moderation parity (RN) | BlueskyModeration | All | open |
| [0171](issues/0171.md) | Sign-off: Lists, Starter Packs & Bookmarks parity (RN) | BlueskyLists / BlueskyFeed | All | open |
| [0172](issues/0172.md) | Sign-off: Navigation shell & deep links parity (RN) | Bluesky-SwiftUI | All | open |
| [0173](issues/0173.md) | Separate Bundle ID for development vs release builds via xcconfig schemes | Build / Config | All | resolved |
| [0174](issues/0174.md) | Automated screenshot capture script for iterating through app screens | Build / Config | All | resolved |
| [0175](issues/0175.md) | UI test automation foundation: launch-arg navigation driver and screenshot harness | Tests / Bluesky-SwiftUI | All | open |
| [0176](issues/0176.md) | UI test suite: home feed (load, rendering, and post interactions) | Tests / BlueskyFeed | All | open |
| [0177](issues/0177.md) | UI test suite: thread view and post action buttons | Tests / BlueskyFeed | All | open |
| [0178](issues/0178.md) | UI test suite: profile screen (own and others) | Tests / BlueskyProfile | All | open |
| [0179](issues/0179.md) | UI test suite: search and discovery | Tests / BlueskySearch | All | open |
| [0180](issues/0180.md) | UI test suite: notifications (list, grouping, and tap routing) | Tests / BlueskyNotifications | All | open |
| [0181](issues/0181.md) | UI test suite: direct messages (conversation list and thread) | Tests / BlueskyMessages | All | open |
| [0182](issues/0182.md) | UI test suite: composer (sheet, character count, and post submission) | Tests / BlueskyComposer | All | open |
| [0183](issues/0183.md) | UI test suite: settings, moderation, and account screens | Tests / BlueskySettings / BlueskyModeration | All | open |
| [0184](issues/0184.md) | Quote-with-media embeds fail to decode: `recordWithMedia` misses the nested `record` wrapper | BlueskyCore / BlueskyFeed | All | open |
| [0185](issues/0185.md) | Launch-time feed and preference fetches are cancelled mid-flight and logged as errors | BlueskyFeed / BlueskySettings / BlueskyNetworking | macOS | open |
| [0186](issues/0186.md) | DM conversation list fails to load: `chat.bsky.convo.listConvos` returns `MethodNotImplemented` | BlueskyMessages / BlueskyNetworking | All | resolved |
| [0187](issues/0187.md) | Feed fetch repeatedly fails with `UpstreamFailure: feed unavailable`; verify retry behavior and error UI | BlueskyFeed | All | open |
| [0188](issues/0188.md) | Create a distinct Beta app icon so dev/test builds are visually distinguishable | Bluesky-SwiftUI / Build / Config | All | open |
| [0189](issues/0189.md) | "Modifying state during view update" — `MainTabView.savedStoreOrCreate()` mutates `@State` inside body evaluation | Bluesky-SwiftUI | All | open |
| [0190](issues/0190.md) | Add Sparkle automatic updates to the Mac app | Bluesky-SwiftUI / BlueskyKit / Build / Config | macOS | open |
| [0191](issues/0191.md) | Release pipeline: code-signed, notarized, stapled DMG for direct distribution | Bluesky-SwiftUI / Build / Config | macOS | open |
| [0192](issues/0192.md) | Release website: hosting for downloads, appcast, and changelog | Bluesky-SwiftUI / Website | macOS | open |
| [0193](issues/0193.md) | DM compose bar on iPhone has no option to attach an image | BlueskyMessages | iOS | open |
| [0194](issues/0194.md) | Sending an image in a DM does not work on macOS | BlueskyMessages | macOS | open |
| [0195](issues/0195.md) | Incoming DMs do not appear until the conversation is reloaded: add getLog polling while messages UI is visible | BlueskyMessages | All | open |
| [0196](issues/0196.md) | macOS top bar: trailing buttons crammed on the right; only the Feeds (`#`) button should remain | Bluesky-SwiftUI | macOS | resolved |
| [0197](issues/0197.md) | macOS: post button should be a floating button at the bottom right, as in the RN app | Bluesky-SwiftUI | macOS | resolved |
| [0198](issues/0198.md) | macOS: replace the sidebar with a hamburger-toggled menu drawer, as in the RN app | Bluesky-SwiftUI | macOS | resolved |
| [0199](issues/0199.md) | macOS Feeds screen shows placeholder "Feed" rows: `#` button routes to the bare SavedFeedsScreen instead of MyFeedsScreen | BlueskyFeed / Bluesky-SwiftUI | macOS / iPadOS | resolved |
| [0200](issues/0200.md) | Remove dead `SavedFeedsScreen` from BlueskyFeed (unreachable after #0199) | BlueskyFeed | All | open |

---

## How to file an issue

1. Pick the next number from the index above.
2. Create `issues/NNNN.md` using the template below.
3. If there are screenshots or other attachments, drop them in `issues/NNNN/` and add them to the Attachments section using inline image syntax (see template).
4. Add a row to the Index table above.
5. Add a row to the open-issues table in `../Bluesky-SwiftUI/CLAUDE.md` (it mirrors a subset of this index).
6. Commit the new issue in this repo with message `#NNNN <issue title>` so it enters git history with its `open` status; commit the table row in `Bluesky-SwiftUI` separately.

## How to update an existing issue

Any change to an issue — status update, added notes, new attachment, or any other edit — requires these steps:

1. Edit `issues/NNNN.md` with the change.
2. If the status changed, update the matching row in the Index table above and (if the issue is listed there) in the open-issues table in `../Bluesky-SwiftUI/CLAUDE.md`.
3. Commit the markdown change in this repo with a `#NNNN`-prefixed message.

When status moves to `resolved` or `closed`, add a `**Closed**` row to the issue's metadata table with today's date. When the move to `resolved` comes from a review-approved issue branch, also add a `**Branch**` row (`issue/NNNN`) naming the repo(s) it lives in. The landing commit is found by its message (`git log --oneline --grep='#NNNN'` in the code repo) — don't record a commit hash, since the squash hash doesn't exist when the issue file is written.

**Adding screenshots:** macOS screenshot filenames contain a **narrow no-break space** (U+202F) before AM/PM — visually identical to a regular space but distinct in bytes. Quoting the literal filename in a `cp` command will fail with "No such file or directory" because of this character.

Claude handles this automatically using a glob that skips the problematic character:

```bash
cp /Users/brennan/Desktop/Screenshot\ YYYY-MM-DD\ at\ H.MM.SS*XM.png issues/NNNN/screenshot.png
```

If Claude cannot copy the file (e.g. no Desktop access), run the copy yourself using the `!` prefix in the Claude Code prompt — your shell has the necessary permissions:

```
! cp /Users/brennan/Desktop/Screenshot\ YYYY-MM-DD\ at\ H.MM.SS*XM.png issues/NNNN/screenshot.png
```

---

## Working an issue (review-gated branch workflow)

All code work for an issue happens on a branch named for the issue (`issue/NNNN`), and **nothing reaches `main` until an independent review approves the diff** — at which point the branch lands as a single squash commit. Each issue runs through a three-role loop:

- **Implementer subagent** — model pinned to **Sonnet**. Implements and verifies the change on the issue branch, committing checkpoints as it goes. Never touches `main`.
- **Reviewer subagent** — model pinned to **Opus**. Reviews the branch diff against the issue and commits its verdict to the issue file in this repo. Does **not** edit code or change status.
- **Orchestrator** (the main session) — picks issues, creates branches, dispatches both subagents, routes review feedback back to the implementer, records token-usage work-log rows, and — only after approval — marks the issue `resolved` and squash-merges the branch to `main`.

Issues are worked **strictly one at a time** — never run two implementers in parallel. The code repos are real working copies shared by every agent; two issues would fight over branch checkouts.

### Which repos branch

Create `issue/NNNN` (same name) in each code repo the fix touches — `Bluesky-SwiftUI`, `BlueskyKit`, or both. The workspace resolves `BlueskyKit @ local`, so whatever branch is checked out in `../BlueskyKit` is what builds. This repo (`Bluesky-Migration`) never branches: issue markdown, work-log rows, and review verdicts commit straight to its `main` with `#NNNN`-prefixed messages.

Commits on a code repo's **`main`** stay clean: one `#NNNN <verb> <title>` squash commit per approved issue (plus unrelated housekeeping). Commits on an **issue branch** are free-form checkpoints — implementation steps, review-round fixes — prefixed `#NNNN`; granularity doesn't matter because the squash merge collapses the branch into one commit on `main`.

**Why a branch per issue, squashed on merge:** stalled work is never discarded — a bailed attempt stays on its branch for the next try to resume; the implementer can checkpoint without polluting `main`; the reviewer examines exactly the diff that will land (`git diff main...issue/NNNN`); and `main` stays readable — one `#NNNN` commit per issue, greppable with `git log --grep`. **After the squash merge the branch is kept, not deleted** — it remains, unchanged, as the granular history of how the work was done.

### Orchestrator: branch → dispatch → review-gate → squash-merge

1. **Refresh the pricing cache if stale.** If `issues/model-pricing.json` is missing or its `fetched` date isn't today, fetch current model prices and rewrite it (once per day, not per issue). See "Token usage and cost tracking" below.
2. If the user named an issue ("fix 0193"), work that one; otherwise pick the lowest-numbered `open` issue that is actionable.
3. **Create the issue branch(es)** from a clean `main` in each code repo the fix will touch: `git switch -c issue/NNNN main`. If the branch already exists from a previous bailed attempt, resume it instead: `git switch issue/NNNN` (read the bail Notes on the issue first).
4. **Dispatch the implementer** — a fresh subagent with the model pinned to Sonnet, given the issue id and instructions to follow "Implementer subagent" below. It works on the issue branch(es) and returns a summary of what changed, how it was verified, and what it committed.
5. **Record the implementer's usage** — append a `## Work log` row to `issues/NNNN.md` (see "Token usage and cost tracking") and commit it in this repo (`#NNNN Work log: implementer round 1`).
6. **Dispatch the reviewer** — a fresh subagent with the model pinned to Opus, given the issue id and the implementer's summary, following "Reviewer subagent" below. A fresh reviewer per round; don't reuse a reviewer across issues. The reviewer commits its verdict to the issue file; afterwards, record its usage as another work-log row (`#NNNN Work log: review round 1`).
7. **If the reviewer requests changes**, send the findings back to the **same implementer agent** (continue it — its context is intact) to address, re-verify, and commit on the branch, then dispatch a fresh review round. If three rounds don't converge, bail per "When the implementer can't finish" — the branch keeps every attempt; nothing is discarded.
8. **On approval, mark the issue `resolved`** (see "Updating the issue on resolve" below) and commit the markdown in this repo.
9. **Squash-merge to `main`** in each code repo that has an `issue/NNNN` branch:

   ```bash
   git switch main
   git merge --squash issue/NNNN
   git commit -m "#NNNN <verb> <title>"
   ```

   One commit, one simple one-line message — the issue file carries the detail (root cause, fix, review, verification, files changed, costs). **Do not delete the branch** — `issue/NNNN` and its commits stay in place, unchanged, as the full history of the work. (Git never recognizes squash merges as merged, so the branch will not show in `git branch --merged`; that's expected.)
10. Confirm both code repos are back on `main`, then move on to the next open issue (or stop if only one was requested).

### Implementer subagent (Sonnet): claim → fix → verify → checkpoint

The implementer starts with fresh context, so its first job is loading the project's conventions before touching anything. The issue branch already exists — confirm with `git branch --show-current` in each code repo you touch before committing, and stay there: never switch branches, never touch `main`, never merge.

1. **Orient in the project.** Read these in order, every time:
   - **`../Bluesky-Migration/Issues.md`** (this file) — status vocabulary, workflow, commit conventions. **Authoritative for issue-tracking workflow.**
   - **`CLAUDE.md`** in `../Bluesky-Migration/` and in `../Bluesky-SwiftUI/` — porting rules (the React Native app is the spec), architecture layering, restricted areas. **Treat their instructions as binding.**
   - **`../Bluesky-Migration/issues/NNNN.md`** — the issue you're working on, in full, including attachments in `issues/NNNN/`.

   If guides disagree, prefer the `CLAUDE.md` files for code/repo conventions and this file for issue-tracking specifics.

2. **Set status to `in-progress`** in `issues/NNNN.md` and the Index here, and commit in this repo (`#NNNN Claim`).
3. **Make the code changes** required by the issue, committing checkpoints on the issue branch(es) as you go — messages prefixed `#NNNN`, granularity at your discretion (it all squashes into one commit on `main`).
4. **Build *and* run the project's verification commands, and confirm tests actually executed and passed.** This step is mandatory and cannot be shortcutted.

   - **Compilation is not verification.** "It builds" / "no type errors" does not count. Tests must actually run. A green build with zero tests run is a failure of this step.
   - **If you wrote or modified tests as part of the fix, you MUST execute those specific tests and observe them pass.** Confirm the test names you added appear in the run output and the result was success. A test that compiles but never ran proves nothing.
   - **Read the output, don't just check the exit code.** "0 tests run", "skipped", "no tests found", or a "build succeeded" line with no test summary are red flags even when the exit code is 0.
   - **If verification cannot be run in your environment**, you have not verified the change. Do not hand it to review as verified — bail per "When the implementer can't finish" below, naming the verification step you couldn't run.
   - **If the build was already failing before you started**, note it on the issue and bail — don't fix unrelated breakage.

5. **Commit your final state on the branch(es), but do not touch the issue markdown beyond the `in-progress` flip** — the resolution sections are the orchestrator's job, after review. Return to the orchestrator with: what changed and why, the files touched per repo, the exact verification command(s) run and what was observed, and anything the reviewer should scrutinize (trade-offs, RN-parity judgment calls, choices that constrain later issues).

When the orchestrator sends back review findings, address every item (or push back with a concrete reason), re-verify, commit on the branch, and return an updated summary the same way.

### Reviewer subagent (Opus): review the branch before it lands

The reviewer also starts fresh: read this file, both `CLAUDE.md` files, and `issues/NNNN.md` with its attachments, then examine each issue branch with `git diff main...HEAD` — that is exactly the diff the squash merge will land on `main`. (`git log main..HEAD --oneline` shows the checkpoint history if the path the implementer took matters.)

Judge the diff against:

- **The issue itself** — does the change deliver the Expected behavior? Does it match the reference screenshots and the React Native client's behavior (read the cited RN files in `../Bluesky-ReactNative/src/` — RN is the spec)?
- **Correctness and idiom** — SwiftUI best practices, sensible state management, the architecture layering rules in `CLAUDE.md` (lower layers never import higher ones; `@MainActor` default isolation in UI targets), code that reads like the surrounding code.
- **Verification credibility** — did the implementer's verification actually demonstrate the behavior, or just compile? Re-run the build/verify commands if in doubt.
- **Downstream impact** — does the change box in a later issue or break another platform (a macOS fix that regresses iOS, or vice versa)?

Record the verdict — **Approve**, or **Request changes** with a specific, actionable list (file, problem, what would satisfy the objection) — by appending it to a `## Review` section in `issues/NNNN.md` (one entry per round, with model and date) and committing it in this repo (`#NNNN Review round N: approve` or `…: request changes`). Return the same verdict to the orchestrator. Review only; never edit code, never commit in the code repos, never change issue status.

### Updating the issue on resolve (orchestrator, after approval)

Edit `issues/NNNN.md` metadata:

- Change Status to `resolved`; update the Index row here and the open-issues table row in `../Bluesky-SwiftUI/CLAUDE.md` (commit that one on the issue branch if one exists in that repo, so it lands with the squash; otherwise as a small commit on its `main`).
- Add a `**Closed**` row with today's date.
- Add a `**Branch**` row with the branch name and repo(s), e.g. `issue/0193 (BlueskyKit, Bluesky-SwiftUI)`. No commit hash — find the landing commit by message: `git log --oneline --grep='#NNNN'`.

Then add a structured summary so the issue becomes a primary-source record:

- **`## Root cause`** — what was actually wrong (often different from the original report). For feature issues, describe the starting state instead.
- **`## Fix`** — the approach taken.
- **`## Review`** — already written per-round by the reviewer; the orchestrator adds a closing line if needed (rounds taken, what the review changed, or "approved first pass").
- **`## Verification`** — the exact command(s) run and what was observed; name any new tests and confirm they ran. Also say what the user should do by hand in the running app to confirm the behavior before closing. Mandatory — this is the audit trail that distinguishes "verified" from "compiled and hoped".
- **`## Files changed`** — bulleted list grouped by repo, one bullet per file, with a short note on each.
- **`## Gotchas`** *(optional)* — surprises, dead ends, non-obvious behavior, or anything a future engineer working on similar code should know.

Commit in this repo (`#NNNN Resolve: <one-line summary>`), then perform the squash merge(s).

Status flow: `open` → `in-progress` → `resolved`. **Never set `closed`** — the user does that after verifying the behavior in the running app.

### Build / verify commands for this project

Run from `../Bluesky-SwiftUI/` (the app) and `../BlueskyKit/` (the package):

- **Package tests** (always, for any fix touching BlueskyKit): `swift test` in `../BlueskyKit/`. Read the summary line and confirm tests executed and passed.
- **macOS app build**: `xcodebuild -workspace Bluesky.xcworkspace -scheme "Bluesky (Beta)" -destination 'platform=macOS' build -quiet`
- **iOS app build** (for iOS-affecting changes): same command with `-destination 'generic/platform=iOS Simulator'`.
- If the issue has UI-test coverage (see the `Tests /` issues in the index), run the relevant UI tests too.

A fix that touches both platforms must build for both. Use the **Beta** scheme for all automated work, never Prod.

### When the implementer can't finish

If the issue is unreproducible, out of scope, the build won't pass after reasonable effort, or three review rounds don't converge, the work is parked on the branch — never discarded:

1. **Commit everything in flight on the branch(es)**, including half-done work (`#NNNN WIP: <state>`). The branch is the parking spot; the next attempt resumes from it.
2. **Switch the code repo(s) back to `main`** and leave the branch in place.
3. **Add a `## Notes` section** to the issue describing what was tried, why work stopped, what you'd try next, and naming the branch (`Work parked on issue/NNNN in <repo>`). For a review-deadlock bail, include the unresolved review findings verbatim. Revert the status to `open` in the issue file and both index tables (the claim only meant anything while work was active).
4. **Commit the markdown in this repo** with message `#NNNN Notes: <one-line bail summary>` (the orchestrator does this), including the work-log rows for the failed sessions — they're real costs.
5. Return with a one-line summary of why work stalled.

Never use `wontfix` or `closed` to escape a stuck issue.

---

## Token usage and cost tracking

Every subagent dispatch gets a usage record on the issue it worked: which model did the work, exactly how many tokens it consumed, and an estimated cost — this is the budget log for the issue. The **orchestrator** records this after the subagent returns — a subagent can't measure its own totals. One row per session: each implementer round (Sonnet) **and** each reviewer round (Opus) gets its own row, so an issue's true cost includes its reviews. Rows are appended to `issues/NNNN.md` and committed in this repo as each round finishes.

### Pricing cache (`issues/model-pricing.json`)

Anthropic publishes prices on the docs site (no API endpoint). Fetch once per day, cache to:

```json
{
  "fetched": "YYYY-MM-DD",
  "source": "https://docs.claude.com/en/docs/about-claude/pricing",
  "currency": "USD per MTok",
  "models": {
    "claude-opus-4-8": { "input": 5.00, "output": 25.00, "cache_write_5m": 6.25, "cache_read": 0.50 }
  }
}
```

If `fetched` is today, use as-is. If the fetch fails, use the stale cache and note the staleness next to the cost; with no cache at all, record tokens and model with `—` for cost. Never trust example numbers over a fresh fetch.

### Getting exact token counts

Claude Code writes each subagent's transcript to `~/.claude/projects/<project-slug>/<session-id>/subagents/agent-<id>.jsonl`, where `<project-slug>` is the working directory with `/`, `.`, and `_` replaced by `-` (the orchestrator usually runs from `Bluesky-SwiftUI`, so look under `-Users-brennan-Developer-Bluesky-Bluesky-SwiftUI`). Assistant lines carry `message.usage` (exact `input_tokens`, `output_tokens`, `cache_read_input_tokens`, `cache_creation_input_tokens`) and `message.model`.

**Dedupe by `requestId`** — one API response can span several JSONL lines repeating the same usage object; summing every line over-counts. Find the newest agent file mentioning the issue id, keep one usage entry per `requestId`, and sum.

```
cost = (input × input_rate + output × output_rate
      + cache_read × cache_read_rate + cache_write × cache_write_5m_rate) / 1,000,000
```

If no transcript is available (different harness), record whatever total the harness reported, or `—`. Never fabricate counts.

### The `## Work log` section

One row per work session, conventionally the last section of the issue file:

```markdown
## Work log

| Date | Role | Model | Input | Output | Cache read | Cache write | Cost |
|---|---|---|---|---|---|---|---|
| 2026-06-11 | implement | claude-sonnet-4-6 | 96 | 23,141 | 4,877,408 | 133,823 | $1.92 |
| 2026-06-11 | review | claude-opus-4-8 | 54 | 8,210 | 1,204,331 | 41,002 | $0.93 |

**Total: $2.85**
```

Update the `**Total**` line whenever a row is appended. Bails get rows too. Don't reformat existing rows.

---

## Issue template

```markdown
# NNNN — Title

| | |
|---|---|
| **Status** | open |
| **Module** | e.g. BlueskyFeed, BlueskyAuth, Bluesky-SwiftUI |
| **Platform** | iOS · macOS · iPadOS · All |
| **First seen** | YYYY-MM-DD |

## Description

What is wrong.

## Steps to reproduce

1. …
2. …
3. …

## Expected behavior

What should happen.

## Actual behavior

What actually happens.

## Attachments

![Description of screenshot](screenshot.png)

## Notes

Any additional context, guesses at root cause, related code locations.
```
