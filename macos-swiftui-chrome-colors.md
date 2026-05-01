# macOS SwiftUI — System Chrome Coloring Reference

## 1. Accent Color (most impactful)

Controls buttons, toggles, sliders, selection highlights, and focus rings.

### Option A: Assets Catalog (recommended)
1. Open `Assets.xcassets`
2. Click `+` → **New Color Set**
3. Name it exactly `AccentColor`
4. Set your desired color (supports light/dark variants)

### Option B: `.tint()` modifier

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(.red)
        }
    }
}
```

---

## 2. Toolbar / Title Bar Background

> Requires macOS 13+

```swift
WindowGroup {
    ContentView()
        .toolbarBackground(Color.red, for: .windowToolbar)
        .toolbarBackground(.visible, for: .windowToolbar)
}
```

---

## 3. Sidebar Background

```swift
// General
.toolbarBackground(Color.red, for: .automatic)

// Targeted (NavigationSplitView)
NavigationSplitView {
    SidebarView()
        .toolbarBackground(Color.red, for: .automatic)
} detail: {
    DetailView()
}
```

---

## 4. NSWindow-Level Tinting (AppKit escape hatch)

For deeper control over the window frame background:

```swift
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.windows.forEach { window in
            window.backgroundColor = NSColor.systemRed
        }
    }
}

@main
struct MyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

---

## 5. Recommended Combination

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(.red)
                .toolbarBackground(
                    Color(red: 0.7, green: 0.1, blue: 0.1),
                    for: .windowToolbar
                )
                .toolbarBackground(.visible, for: .windowToolbar)
        }
    }
}
```

Also set `AccentColor` in `Assets.xcassets` to match.

---

## What You Can't Control

| Element | Controllable? | Notes |
|---|---|---|
| Accent color | ✅ Yes | Via `.tint()` or `AccentColor` asset |
| Toolbar/title bar | ✅ Yes | macOS 13+ only |
| Sidebar | ✅ Yes | Via `.toolbarBackground` |
| Window frame background | ⚠️ Partial | Via `NSWindow.backgroundColor` |
| Outer window border/shadow | ❌ No | System-controlled |
| Menu bar | ❌ No | System-controlled, not per-app |

---

## Quick Tips

- Use `.preferredColorScheme(.dark)` to influence the overall feel without controlling hue
- `AccentColor` in Assets supports **separate light and dark** variants — set both for polish
- `NSColor.systemRed`, `.systemBlue`, etc. are good starting points for NSWindow tinting
- Test on multiple macOS versions — toolbar background API was added in macOS 13 (Ventura)
