import Foundation

struct ClimbingStatistics {
    let monthlyRecords: [MonthlyRecordData]
    let gradeSuccessRates: [GradeSuccessData]
    let weeklyFrequencies: [WeeklyFrequencyData]

    static let empty = ClimbingStatistics(
        monthlyRecords: [],
        gradeSuccessRates: [],
        weeklyFrequencies: []
    )
}

final class StatisticsCalculator {
    private let monthlyStrategy = MonthlyRecordStrategy()
    private let gradeStrategy = GradeSuccessRateStrategy()
    private let weeklyStrategy = WeeklyFrequencyStrategy()

    func calculate(from records: [DailyRecord]) -> ClimbingStatistics {
        ClimbingStatistics(
            monthlyRecords: monthlyStrategy.calculate(from: records),
            gradeSuccessRates: gradeStrategy.calculate(from: records),
            weeklyFrequencies: weeklyStrategy.calculate(from: records)
        )
    }
}
