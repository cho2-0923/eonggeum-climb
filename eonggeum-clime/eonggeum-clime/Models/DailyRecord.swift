import Foundation

struct DailyRecord: Identifiable {
    let id: UUID
    var date: Date
    var gym: ClimbingGym?
    var problems: [ProblemRecord]
}
