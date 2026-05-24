import Foundation
import SwiftData

@Model
final class ClimbingGym {
    var id: UUID
    var name: String
    var address: String?

    init(
        id: UUID = UUID(),
        name: String,
        address: String? = nil
    ) {
        self.id = id
        self.name = name
        self.address = address
    }
}
