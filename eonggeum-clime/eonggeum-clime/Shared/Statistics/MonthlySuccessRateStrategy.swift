import Foundation

struct MonthlySuccessRateStrategy: ClimbingStatisticStrategy {
    func calculate(from records: [DailyRecord]) -> [MonthlySuccessRateData] {
        guard !records.isEmpty else { return [] }

        let calendar = Calendar.current
        var totalsByMonth: [String: Int] = [:]
        var completedByMonth: [String: Int] = [:]

        for record in records {
            let comps = calendar.dateComponents([.year, .month], from: record.date)
            guard let year = comps.year, let month = comps.month else { continue }
            let key = String(format: "%04d-%02d", year, month)

            for problem in record.problems {
                totalsByMonth[key, default: 0] += 1
                if problem.isCompleted {
                    completedByMonth[key, default: 0] += 1
                }
            }
        }

        return totalsByMonth
            .filter { $0.value > 0 }
            .sorted { $0.key < $1.key }
            .map { key, total in
                let month = Int(key.suffix(2)) ?? 0
                let completed = completedByMonth[key] ?? 0
                return MonthlySuccessRateData(
                    sortKey: key,
                    label: "\(month)월",
                    successRate: Double(completed) / Double(total),
                    totalAttempts: total
                )
            }
    }
}
