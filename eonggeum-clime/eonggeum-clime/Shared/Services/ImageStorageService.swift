import Foundation

enum ImageStorageService {
    private static var mediaDirectory: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("media", isDirectory: true)
    }

    static func save(_ data: Data, id: UUID = UUID()) throws -> URL {
        try FileManager.default.createDirectory(at: mediaDirectory, withIntermediateDirectories: true)
        let url = mediaDirectory.appendingPathComponent("\(id.uuidString).jpg")
        try data.write(to: url)
        return url
    }

    static func videoDestinationURL(fileExtension: String = "mov", id: UUID = UUID()) throws -> URL {
        try FileManager.default.createDirectory(at: mediaDirectory, withIntermediateDirectories: true)
        return mediaDirectory.appendingPathComponent("\(id.uuidString).\(fileExtension)")
    }

    static func delete(at url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
}
