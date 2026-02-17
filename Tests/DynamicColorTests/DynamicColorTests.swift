import Testing
import SwiftUI
import UIKit
@testable import DynamicColor

@MainActor
struct DynamicColorTests {

    private func makeDefaults() -> UserDefaults {
        let suiteName = "DynamicColorTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }

    // MARK: - init(uiColorLight:uiColorDark:)

    @Test
    func initWithUIColors() {
        let sut = DynamicColor(uiColorLight: .white, uiColorDark: .black)
        let _ = sut.wrappedValue
    }

    // MARK: - init(light:dark:)

    @Test
    func initWithSwiftUIColors() {
        let sut = DynamicColor(light: .white, dark: .black)
        let _ = sut.wrappedValue
    }

    // MARK: - init(systemColor:) UIColor

    @Test
    func initWithSystemUIColor() {
        let sut = DynamicColor(systemColor: UIColor.systemBlue)
        let _ = sut.wrappedValue
    }

    // MARK: - init(systemColor:) Color

    @Test
    func initWithSystemSwiftUIColor() {
        let sut = DynamicColor(systemColor: Color.blue)
        let _ = sut.wrappedValue
    }

    // MARK: - Theme-based color resolution

    @Test
    func lightThemeReturnsLightColor() {
        let defaults = makeDefaults()
        let store = ThemeStore(defaults: defaults)
        store.theme = .light

        // Resolve the light UIColor to a Color for comparison
        let lightUIColor = UIColor.white
        let expectedColor = Color(lightUIColor)

        let sut = DynamicColor(uiColorLight: lightUIColor, uiColorDark: .black)
        // DynamicColor uses ThemeStore.shared, so we set shared to light
        let previousTheme = ThemeStore.shared.theme
        ThemeStore.shared.theme = .light

        let result = sut.wrappedValue
        #expect(result == expectedColor)

        ThemeStore.shared.theme = previousTheme
    }

    @Test
    func darkThemeReturnsDarkColor() {
        let darkUIColor = UIColor.black
        let expectedColor = Color(darkUIColor)

        let sut = DynamicColor(uiColorLight: .white, uiColorDark: darkUIColor)
        let previousTheme = ThemeStore.shared.theme
        ThemeStore.shared.theme = .dark

        let result = sut.wrappedValue
        #expect(result == expectedColor)

        ThemeStore.shared.theme = previousTheme
    }

    @Test
    func systemThemeReturnsDynamicColor() {
        let sut = DynamicColor(uiColorLight: .white, uiColorDark: .black)
        let previousTheme = ThemeStore.shared.theme
        ThemeStore.shared.theme = .system

        // System theme should produce a valid Color (dynamic UIColor-backed)
        let _ = sut.wrappedValue

        ThemeStore.shared.theme = previousTheme
    }

    // MARK: - Theme switching

    @Test
    func wrappedValueChangesWhenThemeSwitches() {
        let lightUIColor = UIColor.white
        let darkUIColor = UIColor.black
        let sut = DynamicColor(uiColorLight: lightUIColor, uiColorDark: darkUIColor)

        let previousTheme = ThemeStore.shared.theme

        ThemeStore.shared.theme = .light
        let lightResult = sut.wrappedValue

        ThemeStore.shared.theme = .dark
        let darkResult = sut.wrappedValue

        #expect(lightResult == Color(lightUIColor))
        #expect(darkResult == Color(darkUIColor))
        #expect(lightResult != darkResult)

        ThemeStore.shared.theme = previousTheme
    }
}
