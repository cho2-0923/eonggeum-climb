import Foundation
import SwiftData

@Observable
final class CreateRecordViewModel {
    var selectedDate: Date = .now
    var selectedGymName: String = ""

    let gymOptions: [String] = [
        "더클라임 강남",
        "클라이밍파크 홍대",
        "클라이밍 랩",
        "피커스 클라이밍",
    ]

    // 오늘 이전 날짜만 유효
    var canSave: Bool {
        Calendar.current.compare(selectedDate, to: .now, toGranularity: .day) != .orderedDescending
    }

    func save(context: ModelContext) {
        let gym: ClimbingGym? = selectedGymName.isEmpty
            ? nil
            : ClimbingGym(name: selectedGymName)
        let record = DailyRecord(date: selectedDate, gym: gym)
        context.insert(record)
    }
}
