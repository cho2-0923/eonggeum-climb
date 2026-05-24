import Foundation
import SwiftData

@Model
final class DailyRecord {
    var id: UUID
    var date: Date
    var gym: ClimbingGym?
    @Relationship(deleteRule: .cascade, inverse: \ProblemRecord.dailyRecord)
    var problems: [ProblemRecord]
    var notes: String?

    init(
        id: UUID = UUID(),
        date: Date = .now,
        gym: ClimbingGym? = nil,
        problems: [ProblemRecord] = [],
        notes: String? = nil
    ) {
        self.id = id
        self.date = date
        self.gym = gym
        self.problems = problems
        self.notes = notes
    }
}
