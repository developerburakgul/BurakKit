import Testing
import SwiftUI
import UIKit
@testable import DynamicColor

@MainActor
struct DynamicColorTests {

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
    func lightTraitResolvesToLightColor() {
        let lightUIColor = UIColor.white
        let sut = DynamicColor(uiColorLight: lightUIColor, uiColorDark: .black)

        let dynamicUIColor = UIColor(sut.wrappedValue)
        let resolved = dynamicUIColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))

        let expected = lightUIColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        #expect(resolved == expected)
    }

    @Test
    func darkTraitResolvesToDarkColor() {
        let darkUIColor = UIColor.black
        let sut = DynamicColor(uiColorLight: .white, uiColorDark: darkUIColor)

        let dynamicUIColor = UIColor(sut.wrappedValue)
        let resolved = dynamicUIColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))

        let expected = darkUIColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
        #expect(resolved == expected)
    }

    @Test
    func dynamicColorResolvesToDifferentColorsPerTrait() {
        let lightUIColor = UIColor.white
        let darkUIColor = UIColor.black
        let sut = DynamicColor(uiColorLight: lightUIColor, uiColorDark: darkUIColor)

        let dynamicUIColor = UIColor(sut.wrappedValue)

        let lightResolved = dynamicUIColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        let darkResolved = dynamicUIColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))

        #expect(lightResolved == lightUIColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light)))
        #expect(darkResolved == darkUIColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark)))
        #expect(lightResolved != darkResolved)
    }
}
