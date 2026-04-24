# Bluesky Migration

Planning and documentation for migrating the Bluesky iOS client from React Native to native SwiftUI.

## Goal

Full-parity Bluesky client in native SwiftUI targeting iPhone, iPad, and macOS — built module by module, with each module validated before the next begins.

## Documents

| File | Purpose |
|------|---------|
| `Strategy.md` | Phase breakdown, working rhythm, risk register, and success criteria |
| `Migrate-ReactNative-to-SwiftUI.md` | Per-module checklists and validation gates for all 15 modules |
| `ModularArchitecture.md` | Layered Swift package design, protocol-first dependency injection |
| `ProjectStructure.md` | Four sibling repository layout and how they connect |

## Repository Layout

This repo contains planning docs only. The code lives in sibling repositories:

```
ReactNative/
├── Bluesky-ReactNative/   ← original RN app (reference)
├── Bluesky-Migration/     ← this repo: planning docs
├── BlueskyKit/            ← Swift package: all library modules
└── Bluesky-SwiftUI/       ← Xcode project: app target
```

## Tech Stack

- **Language:** Swift 6.0, strict concurrency (`@MainActor` default)
- **UI:** SwiftUI (native, not Catalyst)
- **Platforms:** iOS 18+, iPadOS 18+, macOS 15+
- **Auth:** AT Protocol (atproto) — JWT access + refresh tokens stored in Keychain
- **Networking:** URLSession-based XRPC client
- **Persistence:** Keychain (tokens), UserDefaults (preferences), SwiftData (cache)
- **Architecture:** Protocol-first, layered SPM targets, no global singletons

## Migration Phases

| Phase | Modules | Milestone |
|-------|---------|-----------|
| 0 — Foundation | Auth, Networking, DataStore | Authenticated API calls, data survives restart |
| 1 — Skeleton | Design System, Navigation Shell | 5-tab app navigates, deep links work |
| 2 — Reading | Home Feed, Post Thread, Profile | First dogfoodable build |
| 3 — Engagement | Search, Notifications, DMs, Composer | Full read/write/message flow |
| 4 — Completeness | Moderation, Settings, Remaining Screens | Feature parity, App Store ready |

See `Strategy.md` for the full approach and `Migrate-ReactNative-to-SwiftUI.md` for the detailed per-module checklists.
