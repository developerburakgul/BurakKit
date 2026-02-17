import SwiftUI
import UIKit

public extension Color {

    /// Creates a SwiftUI `Color` from a 6-digit hex string (e.g. `"#FF5733"` or `"FF5733"`).
    ///
    /// The leading `#` is optional.
    init(hex: String) {
        self.init(UIColor(hex: hex))
    }
}
