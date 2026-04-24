# Project Structure

The Swift rewrite lives across four sibling repositories under `~/Developer/ReactNative/`:

```
ReactNative/
├── Bluesky-ReactNative/   ← original React Native app (reference only)
├── Bluesky-Migration/     ← migration planning docs (this repo)
├── BlueskyKit/            ← Swift package: all library modules
└── Bluesky-SwiftUI/       ← Xcode project: the app target
```

---

## BlueskyKit — `../BlueskyKit/`

A standalone Swift package. All reusable logic lives here as library targets. The app itself never contains business logic — it only wires modules together.

**Key files:**
```
BlueskyKit/
├── Package.swift          ← defines all library products and targets
├── README.md              ← module architecture and dependency graph
├── setup.sh               ← scaffolds a new library directory with a stub file
├── Sources/
│   ├── BlueskyCore/       ← shared data types (structs, enums, value types)
│   ├── BlueskyKit/        ← public API protocols + bootstrap logic
│   ├── BlueskyAuth/       ← authentication implementation
│   ├── BlueskyDataStore/  ← persistence implementation
│   └── BlueskyUI/         ← SwiftUI views and components
└── Tests/
    └── BlueskyKitTests/
```

**Library dependency graph** (from BlueskyKit README):
```
BlueskyUI  BlueskyAuth  BlueskyDataStore  (future: BlueskyNetworking, ...)
     \            |            /
              BlueskyKit      ← protocols + bootstrap
                   |
              BlueskyCore     ← shared models, no dependencies
```

See `../BlueskyKit/README.md` for the full design principles and module descriptions.

**Requirements:** Swift 6.0+, iOS 18+, macOS 15+

---

## Bluesky-SwiftUI — `../Bluesky-SwiftUI/`

The Xcode project that produces the app binary. It is intentionally thin — navigation, scene setup, and dependency injection only.

```
Bluesky-SwiftUI/
├── Bluesky.xcworkspace            ← OPEN THIS in Xcode (see below)
├── Bluesky-SwiftUI.xcodeproj      ← the Xcode project (open via workspace)
├── Bluesky-SwiftUI/               ← app source
│   ├── Bluesky_SwiftUIApp.swift   ← @main entry point
│   ├── ContentView.swift          ← placeholder
│   └── Assets.xcassets/
├── BlueskyPackage/                ← bridge package (see below)
│   └── Package.swift
├── Bluesky-SwiftUITests/
├── Bluesky-SwiftUIUITests/
└── Configuration/
    └── Build.xcconfig             ← bundle ID, Swift version, deployment targets
```

**Build configuration** (`Configuration/Build.xcconfig`):
| Setting | Value |
|---------|-------|
| `PRODUCT_BUNDLE_IDENTIFIER` | `co.sstools.Bluesky` |
| `PRODUCT_NAME` | `Bluesky` |
| `SWIFT_VERSION` | `6.0` |
| `SWIFT_DEFAULT_ACTOR_ISOLATION` | `MainActor` |
| `MACOSX_DEPLOYMENT_TARGET` | `26.2` |

---

## How the Pieces Connect

### The bridge package (`BlueskyPackage/`)

Xcode cannot directly add a sibling-folder Swift package to a project and also have it be editable in the same workspace without issues. The workaround is a two-step indirection:

1. `BlueskyPackage/Package.swift` — a minimal package that declares a local dependency on `BlueskyKit` via a relative path:
   ```swift
   .package(path: "../../BlueskyKit")
   ```

2. `Bluesky-SwiftUI.xcodeproj` adds `BlueskyPackage` as its local package dependency. This gives the project a resolved path to `BlueskyKit` without Xcode needing to know about the sibling directly.

### The workspace (`Bluesky.xcworkspace`)

The workspace adds two things:
- `Bluesky-SwiftUI.xcodeproj` — the app project
- `BlueskyKit` (absolute path) — the library package

This lets you open and edit `BlueskyKit` source files directly in Xcode alongside the app target. The build chain resolves `BlueskyKit` through `BlueskyPackage`; the workspace reference is purely for editor visibility.

```
Bluesky.xcworkspace
├── Bluesky-SwiftUI.xcodeproj   ← builds the app
└── BlueskyKit/                 ← editable in the same Xcode session
     (resolved via BlueskyPackage → ../../BlueskyKit)
```

**Always open `Bluesky.xcworkspace`, not the `.xcodeproj` directly.**

---

## Adding a New Library Module to BlueskyKit

1. Run `./setup.sh` after adding the library name inside it, or manually:
   ```
   mkdir -p Sources/BlueskyFoo
   echo "public struct BlueskyFoo {}" > Sources/BlueskyFoo/BlueskyFoo.swift
   ```

2. Register it in `Package.swift`:
   ```swift
   // products
   .library(name: "BlueskyFoo", targets: ["BlueskyFoo"]),

   // targets
   .target(name: "BlueskyFoo", dependencies: ["BlueskyKit", "BlueskyCore"]),
   .testTarget(name: "BlueskyFooTests", dependencies: ["BlueskyFoo"]),
   ```

3. Xcode resolves the new target automatically — no changes needed in `Bluesky-SwiftUI.xcodeproj`.
