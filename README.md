<h1 align="center">BurakKit</h1>

<p align="center">
  <code>Swift 6.2</code> · <code>iOS 14+</code> · <code>SPM</code>
</p>

<p align="center">
  <b>A modular Swift toolkit that speeds up iOS development.</b><br>
  Each module is independent — add only what you need to your project.
</p>


## Modules

| Todo | Done |
|:-----|:-----|
| ⬜ WebService | ~~DynamicColor~~ ✅ |
| | ~~DependencyContainer~~ ✅ |

---



## Module Examples

<details>
<summary>🎨 DynamicColor</summary>

### DynamicColor

A property wrapper that makes theme-aware color management effortless. Automatically switches between **Light**, **Dark**, and **System** appearance modes.

#### Core Components

| Component | Purpose |
|:---|:---|
| `@DynamicColor` | Property wrapper that provides theme-aware colors in SwiftUI views |
| `ThemeStore` | Singleton that manages the app theme and persists it to `UserDefaults` |
| `AppTheme` | Enum defining `.system` / `.light` / `.dark` theme options |

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

```swift
struct ButtonView: View {
    @DynamicColor(systemColor: UIColor.systemBlue)
    var buttonColor

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

> Theme selection is automatically persisted to `UserDefaults`.

#### API Reference

**`@DynamicColor`**

| Initializer | Description |
|:---|:---|
| `init(uiColorLight:uiColorDark:)` | Define with a pair of UIColors |
| `init(light:dark:)` | Define with a pair of SwiftUI Colors |
| `init(systemColor: UIColor)` | Auto-resolve light/dark from a system UIColor |
| `init(systemColor: Color)` | Auto-resolve light/dark from a system SwiftUI Color |
| `init(hexLight:hexDark:)` | Define with a pair of hex strings |
| `init(hex:)` | Single hex string for both modes |

**`ThemeStore`**

| Member | Type | Description |
|:---|:---|:---|
| `.shared` | `ThemeStore` | Singleton access point |
| `.theme` | `AppTheme` | Current theme (Published, persisted to UserDefaults) |

**`AppTheme`**

| Case | Title | Behavior |
|:---|:---|:---|
| `.system` | "System" | Follows device appearance |
| `.light` | "Light" | Always light theme |
| `.dark` | "Dark" | Always dark theme |

</details>

<details>
<summary>📦 DependencyContainer</summary>

### DependencyContainer

A lightweight, protocol-based Dependency Injection container. Thread-safe with `NSLock`, type-safe with `ObjectIdentifier`.

#### Core Components

| Component | Purpose |
|:---|:---|
| `DependencyContainerProtocol` | Protocol defining `register` and `resolve` interface |
| `DependencyContainer` | Thread-safe implementation with `NSLock` and `ObjectIdentifier` keys |

#### 1. Register & Resolve

```swift
import DependencyContainer

let container = DependencyContainer()

// Register with instance
container.register(AuthServiceProtocol.self, service: AuthService())

// Register with factory
container.register(NetworkServiceProtocol.self, factory: {
    NetworkService(baseURL: "https://api.example.com")
})

// Resolve
let authService = container.resolve(AuthServiceProtocol.self)
```

#### 2. Using with Protocol Abstraction

```swift
protocol AnalyticsServiceProtocol {
    func track(event: String)
}

struct FirebaseAnalytics: AnalyticsServiceProtocol {
    func track(event: String) { /* Firebase impl */ }
}

struct MockAnalytics: AnalyticsServiceProtocol {
    func track(event: String) { /* Mock impl */ }
}

// Production
container.register(AnalyticsServiceProtocol.self, service: FirebaseAnalytics())

// Testing
container.register(AnalyticsServiceProtocol.self, service: MockAnalytics())
```

#### API Reference

**`DependencyContainerProtocol`**

| Method | Description |
|:---|:---|
| `register(_:service:)` | Register an instance for a type (`@MainActor`) |
| `register(_:factory:)` | Register via factory closure (`@MainActor`) |
| `resolve(_:) -> T?` | Resolve a registered type (any thread) |

</details>

---

<details>
<summary><b>Installation</b></summary>

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/developerburakgul/BurakKit.git", from: "0.1.0")
]
```

Then add only the modules you need to your target:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "DynamicColor", package: "BurakKit"),
        .product(name: "DependencyContainer", package: "BurakKit"),
    ]
)
```

Or via **Xcode**:

> `File` > `Add Package Dependencies...` > Paste the repo URL > Select the modules you need.

</details>

---

