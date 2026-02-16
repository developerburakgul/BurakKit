<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.2-F05138?style=for-the-badge&logo=swift&logoColor=white" />
  <img src="https://img.shields.io/badge/iOS-14+-007AFF?style=for-the-badge&logo=apple&logoColor=white" />
  <img src="https://img.shields.io/badge/SPM-Compatible-ED523F?style=for-the-badge&logo=swift&logoColor=white" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" />
</p>

# BurakKit

**A modular Swift toolkit that speeds up iOS development.**

Each module is independent — add only what you need to your project.

---

## Modules

### :construction: In Progress
- **DynamicColor** — Theme-aware color management (Light / Dark / System)

### :rocket: Coming Soon
- **DependencyContainer** — Lightweight Dependency Injection container
- **WebService** — Networking layer

### :white_check_mark: Completed
- ~~*None yet — DynamicColor is on its way!*~~

---

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/anthropics/BurakKit.git", from: "1.0.0")
]
```

Then add only the modules you need to your target:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "DynamicColor", package: "BurakKit"),
    ]
)
```

Or via **Xcode**:

> `File` > `Add Package Dependencies...` > Paste the repo URL > Select the modules you need.

---

## :art: DynamicColor

A property wrapper that makes theme-aware color management effortless. Automatically switches between **Light**, **Dark**, and **System** appearance modes.

### Core Components

| Component | Purpose |
|:---|:---|
| `@DynamicColor` | Property wrapper that provides theme-aware colors in SwiftUI views |
| `ThemeStore` | Singleton that manages the app theme and persists it to `UserDefaults` |
| `AppTheme` | Enum defining `.system` / `.light` / `.dark` theme options |

---

### Usage

#### 1. Basic Color Definition

```swift
import DynamicColor

struct ContentView: View {
    // With UIColor
    @DynamicColor(uiColorLight: .white, uiColorDark: .black)
    var backgroundColor

    // With SwiftUI Color
    @DynamicColor(light: .white, dark: .black)
    var textColor

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            Text("Hello!")
                .foregroundStyle(textColor)
        }
    }
}
```

#### 2. Using System Colors

Pass a system color and the light/dark variants are resolved automatically:

```swift
struct ButtonView: View {
    // UIColor.systemBlue -> light & dark variants resolved automatically
    @DynamicColor(systemColor: UIColor.systemBlue)
    var buttonColor

    // Works the same way with SwiftUI Color
    @DynamicColor(systemColor: Color.red)
    var errorColor

    var body: some View {
        Button("Save") { /* ... */ }
            .foregroundStyle(.white)
            .padding()
            .background(buttonColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
```

#### 3. Switching Themes

```swift
struct SettingsView: View {
    @ObservedObject private var themeStore = ThemeStore.shared

    var body: some View {
        List {
            Picker("Theme", selection: $themeStore.theme) {
                ForEach(AppTheme.allCases) { theme in
                    Text(theme.title).tag(theme)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}
```

> Theme selection is automatically persisted to `UserDefaults`. The last choice is restored on app relaunch.

#### 4. Full Example: Profile Card

```swift
struct ProfileCard: View {
    @DynamicColor(light: Color(.systemBackground), dark: Color(.secondarySystemBackground))
    var cardBackground

    @DynamicColor(light: .black, dark: .white)
    var titleColor

    @DynamicColor(systemColor: UIColor.systemGray)
    var subtitleColor

    @DynamicColor(systemColor: Color.blue)
    var accentColor

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(accentColor)
                    .frame(width: 48, height: 48)

                VStack(alignment: .leading) {
                    Text("Burak Gul")
                        .font(.headline)
                        .foregroundStyle(titleColor)

                    Text("iOS Developer")
                        .font(.subheadline)
                        .foregroundStyle(subtitleColor)
                }
            }
        }
        .padding()
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 4)
    }
}
```

---

### How It Works

```
ThemeStore.shared.theme = .dark
         |
         v
  @Published fires
         |
         v
  @DynamicColor (DynamicProperty)
  wrappedValue is re-evaluated
         |
         +-- .system --> UIColor { trait in ... } --> Defers to system
         +-- .light  --> Returns lightUI color
         +-- .dark   --> Returns darkUI color
         |
         v
   SwiftUI View updates automatically
```

---

### API Reference

#### `@DynamicColor`

| Initializer | Description |
|:---|:---|
| `init(uiColorLight:uiColorDark:)` | Define with a pair of UIColors |
| `init(light:dark:)` | Define with a pair of SwiftUI Colors |
| `init(systemColor: UIColor)` | Auto-resolve light/dark from a system UIColor |
| `init(systemColor: Color)` | Auto-resolve light/dark from a system SwiftUI Color |

#### `ThemeStore`

| Member | Type | Description |
|:---|:---|:---|
| `.shared` | `ThemeStore` | Singleton access point |
| `.theme` | `AppTheme` | Current theme (Published, persisted to UserDefaults) |

#### `AppTheme`

| Case | Title | Behavior |
|:---|:---|:---|
| `.system` | "System" | Follows device appearance |
| `.light` | "Light" | Always light theme |
| `.dark` | "Dark" | Always dark theme |

---

## Roadmap

- [ ] **DynamicColor** — Theme-aware color management *(in progress)*
- [ ] **DependencyContainer** — Dependency Injection container
- [ ] **WebService** — Networking layer

---

## License

MIT License. See [LICENSE](LICENSE) for details.
