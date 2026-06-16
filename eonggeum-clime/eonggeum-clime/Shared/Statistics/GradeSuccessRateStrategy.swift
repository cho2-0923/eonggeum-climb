import Foundation

struct GradeSuccessRateStrategy: ClimbingStatisticStrategy {
    func calculate(from records: [DailyRecord]) -> [GradeSuccessData] {
        var totals: [String: Int] = [:]
        var completions: [String: Int] = [:]

        for record in records {
            for problem in record.problems {
                totals[problem.grade, default: 0] += 1
                if problem.isCompleted {
                    completions[problem.grade, default: 0] += 1
                }
            }
        }

        return totals
            .sorted { $0.key < $1.key }
            .map { grade, total in
                GradeSuccessData(grade: grade, total: total, completed: completions[grade] ?? 0)
            }
    }
}
