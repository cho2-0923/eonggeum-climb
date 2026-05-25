import Foundation
import SwiftData

@Observable
final class EditProblemRecordViewModel {
    var grade: String
    var isCompleted: Bool
    var attempts: Int
    var notes: String
    var isSaveFailedAlertShowing = false

    private let problem: ProblemRecord

    init(problem: ProblemRecord) {
        self.problem = problem
        self.grade = problem.grade
        self.isCompleted = problem.isCompleted
        self.attempts = problem.attempts
        self.notes = problem.notes ?? ""
    }

    var canSave: Bool {
        !grade.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func save(context: ModelContext) -> Bool {
        guard canSave else { return false }
        problem.grade = grade.trimmingCharacters(in: .whitespaces)
        problem.isCompleted = isCompleted
        problem.attempts = attempts
        problem.notes = notes.isEmpty ? nil : notes
        do {
            try context.save()
            return true
        } catch {
            isSaveFailedAlertShowing = true
            return false
        }
    }
}
