# Issues

Lightweight issue tracking for bugs and regressions found while testing the Bluesky SwiftUI app.

Issues are described verbally (or with screenshots) and recorded here so work is not interrupted. Each issue gets a unique four-digit number, left-padded with zeros (`0001`, `0002`, …).

---

## Index

| # | Title | Module | Platform | Status |
|---|-------|--------|----------|--------|
| [0001](issues/0001.md) | Account session not persisted across app launches | BlueskyDataStore | macOS | resolved |
| [0002](issues/0002.md) | Home feed posts not loaded after sign-in | BlueskyFeed | All | open |

---

## How to file an issue

1. Pick the next number from the index above.
2. Create `issues/NNNN.md` using the template below.
3. If there are screenshots or other attachments, drop them in `issues/NNNN/` and list them in the Attachments section.
4. Add a row to the Index table above.

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

- `issues/NNNN/screenshot.png` — description

## Notes

Any additional context, guesses at root cause, related code locations.
```
