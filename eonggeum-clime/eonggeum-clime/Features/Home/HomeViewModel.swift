import Foundation
import SwiftData

@Observable
final class HomeViewModel {
    var selectedDate: Date = .now
    var dailyRecord: DailyRecord? = nil

    var isNextDayAllowed: Bool {
        Calendar.current.compare(selectedDate, to: .now, toGranularity: .day) == .orderedAscending
    }

    func goToPreviousDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
    }

    func goToNextDay() {
        guard isNextDayAllowed else { return }
        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
    }

    func fetchRecord(context: ModelContext) {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: selectedDate)
        guard let end = calendar.date(byAdding: .day, value: 1, to: start) else { return }

        let predicate = #Predicate<DailyRecord> { record in
            record.date >= start && record.date < end
        }
        dailyRecord = try? context.fetch(FetchDescriptor(predicate: predicate)).first
    }
}
