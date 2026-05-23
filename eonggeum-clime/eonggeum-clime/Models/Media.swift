import Foundation

struct Media: Identifiable {
    let id: UUID
    var url: URL
    var type: MediaType
}

enum MediaType {
    case photo
    case video
}
