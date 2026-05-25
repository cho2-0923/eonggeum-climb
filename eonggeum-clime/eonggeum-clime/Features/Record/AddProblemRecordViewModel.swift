import Foundation
import SwiftData

@Observable
final class AddProblemRecordViewModel {
    var grade: String = ""
    var isCompleted: Bool = false
    var attempts: Int = 1
    var notes: String = ""

    var canSave: Bool {
        !grade.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func save(context: ModelContext, into dailyRecord: DailyRecord) -> ProblemRecord? {
        guard canSave else { return nil }
        let record = ProblemRecord(
            grade: grade.trimmingCharacters(in: .whitespaces),
            isCompleted: isCompleted,
            attempts: attempts,
            notes: notes.isEmpty ? nil : notes
        )
        context.insert(record)
        dailyRecord.problems.append(record)
        return record
    }
}
