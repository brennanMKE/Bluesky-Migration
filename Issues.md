# Issues

Lightweight issue tracking for bugs and regressions found while testing the Bluesky SwiftUI app.

Issues are described verbally (or with screenshots) and recorded here so work is not interrupted. Each issue gets a unique four-digit number, left-padded with zeros (`0001`, `0002`, …).

---

## Index

| # | Title | Module | Platform | Status |
|---|-------|--------|----------|--------|
| [0001](issues/0001.md) | Account session not persisted across app launches | BlueskyDataStore | macOS | resolved |
| [0002](issues/0002.md) | Home feed posts not loaded after sign-in | BlueskyFeed | All | resolved |
| [0003](issues/0003.md) | Feed list ignores Dark Mode — white background with black text | BlueskyFeed | macOS | resolved |
| [0004](issues/0004.md) | Reply button not functional on post cells | BlueskyFeed | All | resolved |
| [0005](issues/0005.md) | Repost button not functional on post cells | BlueskyFeed | All | resolved |
| [0006](issues/0006.md) | Like/Reaction button not functional on post cells | BlueskyFeed | All | open |
| [0007](issues/0007.md) | Share button not functional on post cells | BlueskyFeed | All | open |
| [0008](issues/0008.md) | Bookmark button missing from post action bar | BlueskyFeed | All | open |
| [0009](issues/0009.md) | Post action buttons lack tooltips on macOS | BlueskyFeed | macOS | open |
| [0010](issues/0010.md) | `getFeed` XRPC call missing required `feed` query parameter | BlueskyFeed | All | open |
| [0011](issues/0011.md) | Module 1 gate: session restore not validated | BlueskyAuth / BlueskyDataStore | All | open |
| [0012](issues/0012.md) | Module 2 gate: networking endpoint groups not live-tested | BlueskyNetworking / BlueskyCore | All | open |
| [0013](issues/0013.md) | Module 3 gate: preferences persistence and cache stale-while-revalidate not validated | BlueskyDataStore | All | open |
| [0014](issues/0014.md) | Module 4: #Preview canvas not validated in Xcode | BlueskyUI | All | open |
| [0015](issues/0015.md) | Module 4 gate: component gallery not validated | BlueskyUI | All | open |
| [0016](issues/0016.md) | Module 5 gate: navigation shell not validated (tabs, back nav, deep links) | Bluesky-SwiftUI | All | open |
| [0017](issues/0017.md) | Module 6 feature: feed filter toggles (hide replies / hide reposts) not implemented | BlueskyFeed | All | open |
| [0018](issues/0018.md) | Module 6 gate: home feed live validation | BlueskyFeed | All | open |
| [0019](issues/0019.md) | Module 7 feature: reply composer not implemented | BlueskyFeed | All | open |
| [0020](issues/0020.md) | Module 7 feature: inline post expansion not implemented | BlueskyFeed | All | open |
| [0021](issues/0021.md) | Module 7 gate: thread view live validation | BlueskyFeed | All | open |
| [0022](issues/0022.md) | Module 8 feature: profile Feeds and Lists tabs not implemented | BlueskyProfile | All | open |
| [0023](issues/0023.md) | Module 8 feature: verified badges and labeler badges not shown on profiles | BlueskyProfile | All | open |
| [0024](issues/0024.md) | Module 8 feature: known followers chip not shown on profiles | BlueskyProfile | All | open |
| [0025](issues/0025.md) | Module 8 gate: profile live validation | BlueskyProfile | All | open |
| [0026](issues/0026.md) | Module 9 feature: trending topics section not implemented | BlueskySearch | All | open |
| [0027](issues/0027.md) | Module 9 feature: hashtag and topic views not implemented | BlueskySearch | All | open |
| [0028](issues/0028.md) | Module 9 gate: search live validation | BlueskySearch | All | open |
| [0029](issues/0029.md) | Module 10 feature: grouped notifications not implemented | BlueskyNotifications | All | open |
| [0030](issues/0030.md) | Module 10 feature: push notification receipt does not open the correct thread | BlueskyNotifications | iOS | open |
| [0031](issues/0031.md) | Module 10 gate: notifications live validation | BlueskyNotifications | All | open |
| [0032](issues/0032.md) | Module 11 feature: image attachments and message requests inbox not implemented | BlueskyMessages | All | open |
| [0033](issues/0033.md) | Module 11 gate: DM and group chat live validation | BlueskyMessages | All | open |
| [0034](issues/0034.md) | Module 12 feature: video picker, link card preview, thread composer, draft persistence not implemented | BlueskyComposer | All | open |
| [0035](issues/0035.md) | Module 12 gate: composer live validation | BlueskyComposer | All | open |
| [0036](issues/0036.md) | Module 13 gate: moderation live validation | BlueskyModeration | All | open |
| [0037](issues/0037.md) | Module 14 gate: settings persistence live validation | BlueskySettings | All | open |
| [0038](issues/0038.md) | Module 15 gate: remaining screens feature parity validation | BlueskyLists / BlueskyFeed / BlueskyModeration / BlueskySettings | All | open |
| [0039](issues/0039.md) | Tapping a post navigates to a blank screen | BlueskyFeed | All | open |
| [0040](issues/0040.md) | Design refinement: revisit app color palette | BlueskyUI | All | open |
| [0041](issues/0041.md) | Action button state may be stale when toggled | BlueskyFeed | All | open |

---

## Issue visualization

`issues/index.html` is an interactive dashboard with swimlane, timeline, and list views. It loads data from `issues/issues.js`, which is generated from the individual `.md` files.

**After filing or updating any issue, regenerate the data file:**

```
! python3 issues/generate.py
```

Open `issues/index.html` directly in a browser — no web server required.

---

## How to file an issue

1. Pick the next number from the index above.
2. Create `issues/NNNN.md` using the template below.
3. If there are screenshots or other attachments, drop them in `issues/NNNN/` and add them to the Attachments section using inline image syntax (see template).
4. Add a row to the Index table above.
5. Run `python3 issues/generate.py` to update the visualization data.

## How to update an existing issue

Any change to an issue — status update, added notes, new attachment, or any other edit — requires these steps:

1. Edit `issues/NNNN.md` with the change.
2. If the status changed, update the matching row in the Index table above.
3. Run `python3 issues/generate.py` to refresh the visualization data.

**Adding screenshots:** Claude cannot copy files from `~/Desktop` due to macOS privacy restrictions. To attach a screenshot, run the copy yourself — paste this into the Claude Code prompt, substituting the actual filename:

```
! cp ~/Desktop/"Screenshot YYYY-MM-DD at H.MM.SS XM.png" issues/NNNN/screenshot.png
```

Alternatively, save or move the screenshot directly into `issues/NNNN/` before asking Claude to reference it.

**Status values:** `open` · `in-progress` · `resolved` · `wontfix`

> **IMPORTANT — do not close issues without explicit confirmation.**
> An issue must **never** be marked `resolved` or `wontfix` unless the user has explicitly said the bug is fixed or won't be addressed. Do not infer resolution from a code change, a commit message, or the filing of a related issue. Always leave status as `open` until the user confirms closure.

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
