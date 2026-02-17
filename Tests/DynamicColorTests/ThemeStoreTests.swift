import Testing
import Foundation
@testable import DynamicColor

@MainActor
struct ThemeStoreTests {

    private func makeDefaults() -> UserDefaults {
        let suiteName = "ThemeStoreTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }

    // MARK: - Default State

    @Test
    func defaultThemeIsSystem() {
        let store = ThemeStore(defaults: makeDefaults())
        #expect(store.theme == .system)
    }

    // MARK: - Persistence

    @Test
    func settingThemePersistsToUserDefaults() {
        let defaults = makeDefaults()
        let store = ThemeStore(defaults: defaults)

        store.theme = .dark
        #expect(defaults.string(forKey: "app_theme") == "dark")

        store.theme = .light
        #expect(defaults.string(forKey: "app_theme") == "light")

        store.theme = .system
        #expect(defaults.string(forKey: "app_theme") == "system")
    }

    @Test
    func initReadsPersistedTheme() {
        let defaults = makeDefaults()
        defaults.set("dark", forKey: "app_theme")

        let store = ThemeStore(defaults: defaults)
        #expect(store.theme == .dark)
    }

    @Test
    func initWithInvalidPersistedValueDefaultsToSystem() {
        let defaults = makeDefaults()
        defaults.set("invalid_value", forKey: "app_theme")

        let store = ThemeStore(defaults: defaults)
        #expect(store.theme == .system)
    }

    @Test
    func initWithNoPersistedValueDefaultsToSystem() {
        let defaults = makeDefaults()
        // no value set
        let store = ThemeStore(defaults: defaults)
        #expect(store.theme == .system)
    }

    // MARK: - Round-trip

    @Test(arguments: AppTheme.allCases)
    func persistenceRoundTrip(theme: AppTheme) {
        let defaults = makeDefaults()
        let store = ThemeStore(defaults: defaults)
        store.theme = theme

        let restored = ThemeStore(defaults: defaults)
        #expect(restored.theme == theme)
    }

    // MARK: - Shared Singleton

    @Test
    func sharedInstanceIsSameReference() {
        let a = ThemeStore.shared
        let b = ThemeStore.shared
        #expect(a === b)
    }
}
