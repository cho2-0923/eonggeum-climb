import Foundation
import SwiftData

@Model
final class Media {
    var id: UUID
    var url: URL
    var type: MediaType
    var problemRecord: ProblemRecord?

    init(
        id: UUID = UUID(),
        url: URL,
        type: MediaType
    ) {
        self.id = id
        self.url = url
        self.type = type
    }
}

enum MediaType: String, Codable {
    case photo
    case video
}
