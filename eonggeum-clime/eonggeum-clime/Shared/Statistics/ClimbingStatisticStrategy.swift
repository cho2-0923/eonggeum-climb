import Foundation

protocol ClimbingStatisticStrategy {
    associatedtype Output
    func calculate(from records: [DailyRecord]) -> Output
}

// MARK: - Result Types

struct MonthlyRecordData: Identifiable {
    let id = UUID()
    let sortKey: String      // "2025-01"
    let label: String        // "1월"
    let count: Int
}

struct GradeSuccessData: Identifiable {
    let id = UUID()
    let grade: String
    let total: Int
    let completed: Int
    var successRate: Double { total == 0 ? 0 : Double(completed) / Double(total) }
}

struct WeeklyFrequencyData: Identifiable {
    let id = UUID()
    let sortKey: String      // "2025-W23"
    let label: String        // "6/2~"
    let sessionCount: Int
}

struct MonthlySuccessRateData: Identifiable {
    let id = UUID()
    let sortKey: String      // "2025-01"
    let label: String        // "1월"
    let successRate: Double  // 0.0 ~ 1.0
    let totalAttempts: Int
}
