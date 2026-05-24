import Foundation
import SwiftData

@Observable
final class CreateRecordViewModel {
    var selectedDate: Date = .now
    var selectedGymName: String = ""
    var isDuplicateDateAlertShowing = false
    var isSaveFailedAlertShowing = false

    let gymOptions: [String] = [
        "더클라임 강남",
        "클라이밍파크 홍대",
        "클라이밍 랩",
        "피커스 클라이밍",
    ]

    var canSave: Bool {
        Calendar.current.compare(selectedDate, to: .now, toGranularity: .day) != .orderedDescending
    }

    @discardableResult
    func save(context: ModelContext) -> DailyRecord? {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: selectedDate)
        guard let end = calendar.date(byAdding: .day, value: 1, to: start) else { return nil }

        let predicate = #Predicate<DailyRecord> { record in
            record.date >= start && record.date < end
        }

        do {
            let existing = try context.fetch(FetchDescriptor(predicate: predicate))
            guard existing.isEmpty else {
                isDuplicateDateAlertShowing = true
                return nil
            }

            let gym: ClimbingGym? = selectedGymName.isEmpty ? nil : ClimbingGym(name: selectedGymName)
            let record = DailyRecord(date: selectedDate, gym: gym)
            context.insert(record)
            try context.save()
            return record
        } catch {
            isSaveFailedAlertShowing = true
            return nil
        }
    }
}
