import Foundation

struct ProblemRecord: Identifiable {
    let id: UUID
    var grade: String
    var isCompleted: Bool
    var media: [Media]
}
