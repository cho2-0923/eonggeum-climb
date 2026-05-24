import Foundation
import SwiftData

@Model
final class ProblemRecord {
    var id: UUID
    var grade: String
    var isCompleted: Bool
    var attempts: Int
    @Relationship(deleteRule: .cascade, inverse: \Media.problemRecord)
    var media: [Media]
    var notes: String?
    var dailyRecord: DailyRecord?

    init(
        id: UUID = UUID(),
        grade: String,
        isCompleted: Bool = false,
        attempts: Int = 0,
        media: [Media] = [],
        notes: String? = nil
    ) {
        self.id = id
        self.grade = grade
        self.isCompleted = isCompleted
        self.attempts = attempts
        self.media = media
        self.notes = notes
    }
}
