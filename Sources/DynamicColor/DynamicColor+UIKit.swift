import SwiftUI
import UIKit

@MainActor
@propertyWrapper
public struct DynamicColor: DynamicProperty {
    private let lightUI: UIColor
    private let darkUI: UIColor

    public var wrappedValue: Color {
        let light = self.lightUI
        let dark = self.darkUI
        let dynamic = UIColor { trait in
            #if DEBUG
            print("[DynamicColor] resolving – style: \(trait.userInterfaceStyle.rawValue)")
            #endif
            return trait.userInterfaceStyle == .dark ? dark : light
        }
        return Color(dynamic)
    }

    // MARK: - Initializers

    public init(uiColorLight: UIColor, uiColorDark: UIColor) {
        self.lightUI = uiColorLight
        self.darkUI = uiColorDark
    }

    public init(light: Color, dark: Color) {
        self.lightUI = UIColor(light)
        self.darkUI = UIColor(dark)
    }

    public init(systemColor: UIColor) {
        self.lightUI = systemColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        self.darkUI  = systemColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
    }

    public init(systemColor: Color) {
        let uiColor = UIColor(systemColor)
        self.lightUI = uiColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        self.darkUI  = uiColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
    }

    /// Creates a `DynamicColor` from two 6-digit hex strings for light and dark modes.
    public init(hexLight: String, hexDark: String) {
        self.lightUI = UIColor(hex: hexLight)
        self.darkUI = UIColor(hex: hexDark)
    }

    /// Creates a `DynamicColor` from a single 6-digit hex string used for both light and dark modes.
    public init(hex: String) {
        let color = UIColor(hex: hex)
        self.lightUI = color
        self.darkUI = color
    }
}
