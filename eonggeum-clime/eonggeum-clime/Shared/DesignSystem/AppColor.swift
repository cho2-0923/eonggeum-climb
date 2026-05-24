import SwiftUI

extension Color {
    enum App {
        static let primary      = Color(red: 0.95, green: 0.42, blue: 0.24)
        static let secondary    = Color(UIColor.secondarySystemFill)

        static let background   = Color(UIColor.systemBackground)
        static let surface      = Color(UIColor.secondarySystemBackground)

        static let textPrimary  = Color(UIColor.label)
        static let textSecondary = Color(UIColor.secondaryLabel)

        static let success      = Color(red: 0.20, green: 0.72, blue: 0.44)
        static let warning      = Color(red: 1.00, green: 0.76, blue: 0.00)
        static let error        = Color(red: 0.93, green: 0.25, blue: 0.25)
    }
}
