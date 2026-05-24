import Foundation

struct ClimbingGym: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var address: String?
}
