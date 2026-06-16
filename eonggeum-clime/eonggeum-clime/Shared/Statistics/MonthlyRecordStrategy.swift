import Foundation

struct MonthlyRecordStrategy: ClimbingStatisticStrategy {
    func calculate(from records: [DailyRecord]) -> [MonthlyRecordData] {
        guard !records.isEmpty else { return [] }

        let calendar = Calendar.current
        var counts: [String: Int] = [:]

        for record in records {
            let comps = calendar.dateComponents([.year, .month], from: record.date)
            guard let year = comps.year, let month = comps.month else { continue }
            let key = String(format: "%04d-%02d", year, month)
            counts[key, default: 0] += 1
        }

        return counts
            .sorted { $0.key < $1.key }
            .map { key, count in
                let month = Int(key.suffix(2)) ?? 0
                return MonthlyRecordData(sortKey: key, label: "\(month)월", count: count)
            }
    }
}
