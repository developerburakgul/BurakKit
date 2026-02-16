#if canImport(UIKit) && !os(watchOS)

import SwiftUI
import UIKit

@MainActor
@propertyWrapper
public struct DynamicColor: DynamicProperty {
    @ObservedObject private var themeStore = ThemeStore.shared

    private let lightUI: UIColor
    private let darkUI: UIColor

    public var wrappedValue: Color {
        #if DEBUG
        print("🟠 DynamicColor evaluated. theme=\(themeStore.theme)")
        #endif

        switch themeStore.theme {
        case .system:
            let dynamic = UIColor { trait in
                #if DEBUG
                print("🧪 provider style:", trait.userInterfaceStyle.rawValue) // 0 unspecified, 1 light, 2 dark
                #endif
                return trait.userInterfaceStyle == .dark ? self.darkUI : self.lightUI
            }
            return Color(dynamic)
        case .light:
            return Color(lightUI)

        case .dark:
            return Color(darkUI)
        }
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
}

#endif
