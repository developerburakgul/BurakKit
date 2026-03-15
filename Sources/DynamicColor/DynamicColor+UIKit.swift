import SwiftUI
import UIKit

@MainActor
@propertyWrapper
public struct DynamicColor: DynamicProperty {
    private let resolvedColor: Color

    public var wrappedValue: Color {
        resolvedColor
    }

    // MARK: - Private

    /// Creates the dynamic UIColor in a nonisolated context so the provider
    /// closure does NOT inherit @MainActor isolation and can be safely
    /// called from any thread (e.g. SwiftUI's AsyncRenderer on iOS 26+).
    nonisolated private static func makeColor(light: UIColor, dark: UIColor) -> Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? dark : light
        })
    }

    private init(light: UIColor, dark: UIColor) {
        self.resolvedColor = Self.makeColor(light: light, dark: dark)
    }

    // MARK: - Initializers

    public init(uiColorLight: UIColor, uiColorDark: UIColor) {
        self.init(light: uiColorLight, dark: uiColorDark)
    }

    public init(light: Color, dark: Color) {
        self.init(light: UIColor(light), dark: UIColor(dark))
    }

    public init(systemColor: UIColor) {
        self.init(
            light: systemColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light)),
            dark: systemColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
        )
    }

    public init(systemColor: Color) {
        let uiColor = UIColor(systemColor)
        self.init(
            light: uiColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light)),
            dark: uiColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
        )
    }

    /// Creates a `DynamicColor` from two 6-digit hex strings for light and dark modes.
    public init(hexLight: String, hexDark: String) {
        self.init(light: UIColor(hex: hexLight), dark: UIColor(hex: hexDark))
    }

    /// Creates a `DynamicColor` from a single 6-digit hex string used for both light and dark modes.
    public init(hex: String) {
        let color = UIColor(hex: hex)
        self.init(light: color, dark: color)
    }
}
