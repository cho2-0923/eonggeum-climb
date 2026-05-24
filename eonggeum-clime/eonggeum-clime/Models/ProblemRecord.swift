import Foundation

struct ProblemRecord: Identifiable, Hashable, Codable {
    let id: UUID
    var grade: String
    var isCompleted: Bool
    var attempts: Int
    var media: [Media]
    var notes: String?
}
