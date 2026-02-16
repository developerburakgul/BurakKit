import Testing
@testable import DynamicColor

struct AppThemeTests {

    // MARK: - Raw Values

    @Test
    func rawValues() {
        #expect(AppTheme.system.rawValue == "system")
        #expect(AppTheme.light.rawValue == "light")
        #expect(AppTheme.dark.rawValue == "dark")
    }

    // MARK: - Identifiable

    @Test
    func idMatchesRawValue() {
        for theme in AppTheme.allCases {
            #expect(theme.id == theme.rawValue)
        }
    }

    // MARK: - CaseIterable

    @Test
    func allCasesContainsThreeCases() {
        #expect(AppTheme.allCases.count == 3)
        #expect(AppTheme.allCases == [.system, .light, .dark])
    }

    // MARK: - Title

    @Test(arguments: [
        (AppTheme.system, "System"),
        (AppTheme.light, "Light"),
        (AppTheme.dark, "Dark"),
    ])
    func title(theme: AppTheme, expected: String) {
        #expect(theme.title == expected)
    }

    // MARK: - Init from RawValue

    @Test
    func initFromValidRawValue() {
        #expect(AppTheme(rawValue: "system") == .system)
        #expect(AppTheme(rawValue: "light") == .light)
        #expect(AppTheme(rawValue: "dark") == .dark)
    }

    @Test
    func initFromInvalidRawValueReturnsNil() {
        #expect(AppTheme(rawValue: "") == nil)
        #expect(AppTheme(rawValue: "invalid") == nil)
        #expect(AppTheme(rawValue: "System") == nil)
    }

    // MARK: - Hashable

    @Test
    func hashableConformance() {
        let set: Set<AppTheme> = [.system, .light, .dark, .system]
        #expect(set.count == 3)
    }
}
