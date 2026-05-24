import Foundation

struct Media: Identifiable, Hashable, Codable {
    let id: UUID
    var url: URL
    var type: MediaType
}

enum MediaType: String, Hashable, Codable {
    case photo
    case video
}
