import Testing
import SwiftUI
import UIKit
@testable import DynamicColor

@MainActor
struct HexColorTests {

    // MARK: - UIColor+Hex

    @Test
    func uiColorFromHexWithHash() {
        let color = UIColor(hex: "#FF0000")

        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        #expect(r == 1.0)
        #expect(g == 0.0)
        #expect(b == 0.0)
        #expect(a == 1.0)
    }

    @Test
    func uiColorFromHexWithoutHash() {
        let color = UIColor(hex: "00FF00")

        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        #expect(r == 0.0)
        #expect(g == 1.0)
        #expect(b == 0.0)
        #expect(a == 1.0)
    }

    @Test
    func uiColorFromHexBlue() {
        let color = UIColor(hex: "#0000FF")

        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        #expect(r == 0.0)
        #expect(g == 0.0)
        #expect(b == 1.0)
        #expect(a == 1.0)
    }

    @Test
    func uiColorFromHexWhite() {
        let color = UIColor(hex: "FFFFFF")

        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        #expect(r == 1.0)
        #expect(g == 1.0)
        #expect(b == 1.0)
    }

    @Test
    func uiColorFromHexBlack() {
        let color = UIColor(hex: "000000")

        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        #expect(r == 0.0)
        #expect(g == 0.0)
        #expect(b == 0.0)
    }

    @Test
    func uiColorFromHexCustomColor() {
        let color = UIColor(hex: "#FF5733")

        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        #expect(abs(r - 1.0) < 0.01)
        #expect(abs(g - 0x57 / 255.0) < 0.01)
        #expect(abs(b - 0x33 / 255.0) < 0.01)
    }

    // MARK: - Color+Hex

    @Test
    func colorFromHex() {
        let color = Color(hex: "#0000FF")
        let expected = Color(UIColor(hex: "#0000FF"))
        #expect(color == expected)
    }

    // MARK: - DynamicColor hex initializers

    @Test
    func dynamicColorFromHexLightAndDark() {
        let sut = DynamicColor(hexLight: "#FFFFFF", hexDark: "#000000")
        let _ = sut.wrappedValue
    }

    @Test
    func dynamicColorFromSingleHex() {
        let sut = DynamicColor(hex: "#FF5733")
        let _ = sut.wrappedValue
    }

    @Test
    func dynamicColorHexResolvesCorrectlyForLightTheme() {
        let previousTheme = ThemeStore.shared.theme
        ThemeStore.shared.theme = .light

        let sut = DynamicColor(hexLight: "#FFFFFF", hexDark: "#000000")
        let result = sut.wrappedValue
        let expected = Color(UIColor(hex: "#FFFFFF"))

        #expect(result == expected)

        ThemeStore.shared.theme = previousTheme
    }

    @Test
    func dynamicColorHexResolvesCorrectlyForDarkTheme() {
        let previousTheme = ThemeStore.shared.theme
        ThemeStore.shared.theme = .dark

        let sut = DynamicColor(hexLight: "#FFFFFF", hexDark: "#000000")
        let result = sut.wrappedValue
        let expected = Color(UIColor(hex: "#000000"))

        #expect(result == expected)

        ThemeStore.shared.theme = previousTheme
    }
}
