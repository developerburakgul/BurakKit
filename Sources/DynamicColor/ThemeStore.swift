import Foundation
import UIKit
import Combine

public enum AppTheme: String, CaseIterable, Identifiable, Hashable, Sendable {
    case system
    case light
    case dark

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

@MainActor
public final class ThemeStore: ObservableObject, Sendable {
    public static let shared = ThemeStore()
    private let key: String = "app_theme"
    private let defaults: UserDefaults

    @Published
    public var theme: AppTheme {
        didSet {
            defaults.set(theme.rawValue, forKey: key)
            applyInterfaceStyle()
            #if DEBUG
            print("[ThemeStore] theme changed to \(theme.rawValue)")
            #endif
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let raw = defaults.string(forKey: key)
        self.theme = AppTheme(rawValue: raw ?? "") ?? .system
        applyInterfaceStyle()
    }

    public func applyInterfaceStyle() {
        let style: UIUserInterfaceStyle = switch theme {
        case .system: .unspecified
        case .light:  .light
        case .dark:   .dark
        }
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = style
            }
        }
        #if DEBUG
        print("[ThemeStore] applyInterfaceStyle – style: \(style.rawValue)")
        #endif
    }
}
