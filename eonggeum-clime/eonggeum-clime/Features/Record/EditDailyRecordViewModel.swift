import Foundation
import SwiftData

@Observable
final class EditDailyRecordViewModel {
    var selectedGymName: String
    var notes: String
    var isSaveFailedAlertShowing = false

    let gymOptions: [String] = [
        "더클라임 강남",
        "클라이밍파크 홍대",
        "클라이밍 랩",
        "피커스 클라이밍",
    ]

    private let record: DailyRecord

    init(record: DailyRecord) {
        self.record = record
        self.selectedGymName = record.gym?.name ?? ""
        self.notes = record.notes ?? ""
    }

    func save(context: ModelContext) -> Bool {
        if selectedGymName.isEmpty {
            if let oldGym = record.gym {
                context.delete(oldGym)
            }
            record.gym = nil
        } else if let gym = record.gym {
            gym.name = selectedGymName
        } else {
            let gym = ClimbingGym(name: selectedGymName)
            context.insert(gym)
            record.gym = gym
        }
        record.notes = notes.isEmpty ? nil : notes
        do {
            try context.save()
            return true
        } catch {
            isSaveFailedAlertShowing = true
            return false
        }
    }
}
