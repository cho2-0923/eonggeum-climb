import Foundation

struct DailyRecord: Identifiable, Hashable, Codable {
    let id: UUID
    var date: Date
    var gym: ClimbingGym?
    var problems: [ProblemRecord]
    var notes: String?
}
