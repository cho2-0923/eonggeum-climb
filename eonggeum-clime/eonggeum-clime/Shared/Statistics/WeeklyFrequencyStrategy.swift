import Foundation

struct WeeklyFrequencyStrategy: ClimbingStatisticStrategy {
    func calculate(from records: [DailyRecord]) -> [WeeklyFrequencyData] {
        guard !records.isEmpty else { return [] }

        var calendar = Calendar.current
        calendar.firstWeekday = 2  // 월요일 시작

        var weekly: [String: Int] = [:]
        var weekStartDates: [String: Date] = [:]

        for record in records {
            let comps = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: record.date)
            guard let year = comps.yearForWeekOfYear, let week = comps.weekOfYear else { continue }
            let key = String(format: "%04d-W%02d", year, week)
            weekly[key, default: 0] += 1

            if weekStartDates[key] == nil {
                var startComps = DateComponents()
                startComps.yearForWeekOfYear = year
                startComps.weekOfYear = week
                startComps.weekday = calendar.firstWeekday
                weekStartDates[key] = calendar.date(from: startComps)
            }
        }

        return weekly
            .sorted { $0.key < $1.key }
            .map { key, count in
                let label: String
                if let start = weekStartDates[key] {
                    let m = calendar.component(.month, from: start)
                    let d = calendar.component(.day, from: start)
                    label = "\(m)/\(d)~"
                } else {
                    label = key
                }
                return WeeklyFrequencyData(sortKey: key, label: label, sessionCount: count)
            }
    }
}
