# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

Planning and tracking documents only. There is no code here. The actual Swift code lives in two sibling repositories:

- `../BlueskyKit/` — Swift package containing all library modules (`Package.swift`, `Sources/`, `Tests/`)
- `../Bluesky-SwiftUI/` — Xcode app target (always open via `Bluesky.xcworkspace`, not the `.xcodeproj`)

The React Native reference app is in `../Bluesky-ReactNative/`.

## Session start protocol

**Always read `Progress.md` first.** It contains the current phase, active module, active checklist item, and the running completion log. This is the fastest way to resume work without re-reading all the planning docs.

**Check for RN drift when resuming after a gap.** `Progress.md` records the RN baseline commit. Run the drift command there to see if `../Bluesky-ReactNative` has advanced; if it has, review the diff before continuing migration work.

## Document map

| File | Purpose |
|------|---------|
| `Progress.md` | Current status, up-next checklist, completion log, decisions made, session notes — the living record |
| `CHANGELOG.md` | Append-only history of completed work, grouped by date and module |
| `Strategy.md` | 4-phase breakdown, working rhythm, risk register, deferred decisions, success criteria |
| `Migrate-ReactNative-to-SwiftUI.md` | Authoritative per-module checklists (15 modules) and validation gates — the spec for what to build |
| `ModularArchitecture.md` | Layered Swift package design, protocol-first DI, dependency graph, what goes in each layer |
| `ProjectStructure.md` | Four sibling repos, workspace setup, bridge package pattern, how to add a new library module |
| `Issues.md` | Index of open bugs and regressions; template for filing new issues |
| `issues/NNNN.md` | Individual issue files (four-digit zero-padded number); attachments in `issues/NNNN/` |

## Issue workflow

When a bug or regression is spotted during testing, **file it rather than fixing it immediately**:

1. Read `Issues.md` to find the next available number.
2. Create `issues/NNNN.md` from the template in `Issues.md`.
3. Drop any screenshots or attachments in `issues/NNNN/`.
4. Add a row to the index table in `Issues.md`.

When an issue is fixed: update its `Status` to `resolved` in `issues/NNNN.md` and in the `Issues.md` index.

## Tracking workflow

When a checklist item is completed:
1. Tick the checkbox in `Progress.md` (Up Next section)
2. Tick the matching checkbox in `Migrate-ReactNative-to-SwiftUI.md`
3. Append a row to the Completion Log table in `Progress.md`
4. Append an entry to `CHANGELOG.md` under today's date

When a module gate passes: update the Current Status table in `Progress.md` and advance Up Next to the next module's items.

When a deferred decision is resolved: fill in the Decisions Made table in `Progress.md` and update the Deferred Decisions section in `Strategy.md`.

## Architecture constraints (from ModularArchitecture.md)

Strict layering — a lower layer never imports a higher one:

- **Layer 0 `BlueskyCore`** — plain Swift value types, no actor isolation, no dependencies
- **Layer 1 `BlueskyKit`** — protocols + DI bootstrap; depends on Core
- **Layer 2** (`BlueskyAuth`, `BlueskyDataStore`, `BlueskyUI`, `BlueskyNetworking`) — implementations; depend on Kit + Core
- **Layer 3** (feature modules: `BlueskyFeed`, `BlueskyProfile`, etc.) — depend on Layer 2 as needed

Protocol requirements that are I/O-bound (`AccountStore`, `PreferencesStore`, `NetworkClient`) carry `nonisolated` so actor implementations satisfy them without inheriting `@MainActor`. UI-state protocols (`SessionManaging`) stay `@MainActor`.
