import UIKit

public extension UIColor {

    /// Creates a color from a 6-digit hex string (e.g. `"#FF5733"` or `"FF5733"`).
    ///
    /// The leading `#` is optional.
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        precondition(hexSanitized.count == 6, "Hex string must be exactly 6 characters (RRGGBB). Got: \"\(hex)\"")

        var rgb: UInt64 = 0
        let success = Scanner(string: hexSanitized).scanHexInt64(&rgb)
        precondition(success, "Invalid hex characters in: \"\(hex)\"")

        let r = CGFloat((rgb >> 16) & 0xFF) / 255
        let g = CGFloat((rgb >> 8) & 0xFF) / 255
        let b = CGFloat(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
