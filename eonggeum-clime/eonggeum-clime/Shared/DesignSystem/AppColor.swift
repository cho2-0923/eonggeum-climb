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

        // 난이도 색상: V등급, 한국 암장 색상명, 난이도 레이블 지원
        static func grade(_ grade: String) -> Color {
            let g = grade.lowercased()
            switch true {
            case g.hasPrefix("v0"), g.hasPrefix("v1"), g.hasPrefix("v2"),
                 g.contains("초급"), g.contains("흰"), g.contains("white"), g.contains("초록"), g.contains("green"):
                return .App.success
            case g.hasPrefix("v3"), g.hasPrefix("v4"),
                 g.contains("파랑"), g.contains("blue"), g.contains("중급"):
                return Color(red: 0.25, green: 0.53, blue: 0.96)
            case g.hasPrefix("v5"), g.hasPrefix("v6"),
                 g.contains("노랑"), g.contains("yellow"), g.contains("고급"):
                return .App.warning
            case g.hasPrefix("v7"), g.hasPrefix("v8"),
                 g.contains("주황"), g.contains("orange"), g.contains("오렌지"):
                return .App.primary
            case g.hasPrefix("v9"), g.contains("v10"), g.contains("v11"),
                 g.contains("빨강"), g.contains("red"), g.contains("최고급"), g.contains("특급"):
                return .App.error
            case g.contains("보라"), g.contains("purple"):
                return Color(red: 0.60, green: 0.25, blue: 0.85)
            case g.contains("검정"), g.contains("black"):
                return Color(red: 0.20, green: 0.20, blue: 0.20)
            default:
                return .App.primary
            }
        }
    }
}
