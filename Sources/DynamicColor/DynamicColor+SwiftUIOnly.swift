#if os(watchOS)

import SwiftUI

@MainActor
@propertyWrapper
public struct DynamicColor: DynamicProperty {
    @ObservedObject private var themeStore = ThemeStore.shared
    @Environment(\.colorScheme) private var scheme

    private let light: Color
    private let dark: Color

    public var wrappedValue: Color {
        #if DEBUG
        print("🟠 DynamicColor evaluated. theme=\(themeStore.theme)")
        #endif

        switch themeStore.theme {
        case .system:
            return scheme == .dark ? dark : light
        case .light:
            return light
        case .dark:
            return dark
        }
    }

    // MARK: - Initializers

    public init(light: Color, dark: Color) {
        self.light = light
        self.dark = dark
    }

    /// UIKit yokken "systemColor" karşılığı: semantic Color (örn: .primary, .background)
    public init(systemColor: Color) {
        self.light = systemColor
        self.dark  = systemColor
    }
}

#endif
