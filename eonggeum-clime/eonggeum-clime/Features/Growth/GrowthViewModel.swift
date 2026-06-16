import Foundation
import Observation

@Observable
final class GrowthViewModel {
    var statistics: ClimbingStatistics = .empty

    private let calculator = StatisticsCalculator()

    func update(records: [DailyRecord]) {
        statistics = calculator.calculate(from: records)
    }
}
