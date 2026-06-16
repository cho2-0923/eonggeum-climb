import Foundation
import PhotosUI
import SwiftUI
import SwiftData

@Observable
final class EditProblemRecordViewModel {
    var grade: String
    var isCompleted: Bool
    var attempts: Int
    var notes: String
    var isSaveFailedAlertShowing = false
    var isImageLoadFailedAlertShowing = false
    var isVideoLoadFailedAlertShowing = false
    var selectedPhotoItems: [PhotosPickerItem] = []
    var newImages: [UIImage] = []
    var selectedVideoItems: [PhotosPickerItem] = []
    var newVideoURLs: [URL] = []
    private var mediaToDeleteIDs: Set<UUID> = []

    private let problem: ProblemRecord

    var existingMedia: [Media] {
        problem.media.filter { !mediaToDeleteIDs.contains($0.id) }
    }

    init(problem: ProblemRecord) {
        self.problem = problem
        self.grade = problem.grade
        self.isCompleted = problem.isCompleted
        self.attempts = problem.attempts
        self.notes = problem.notes ?? ""
    }

    var canSave: Bool {
        !grade.trimmingCharacters(in: .whitespaces).isEmpty
    }

    @MainActor
    func loadImages(from items: [PhotosPickerItem]) async {
        newImages = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                newImages.append(image)
            } else {
                isImageLoadFailedAlertShowing = true
            }
        }
    }

    @MainActor
    func loadVideos(from items: [PhotosPickerItem]) async {
        newVideoURLs = []
        for item in items {
            if let video = try? await item.loadTransferable(type: VideoFile.self) {
                newVideoURLs.append(video.url)
            } else {
                isVideoLoadFailedAlertShowing = true
            }
        }
    }

    func markForDeletion(_ media: Media) {
        mediaToDeleteIDs.insert(media.id)
    }

    func save(context: ModelContext) -> Bool {
        guard canSave else { return false }
        problem.grade = grade.trimmingCharacters(in: .whitespaces)
        problem.isCompleted = isCompleted
        problem.attempts = attempts
        problem.notes = notes.isEmpty ? nil : notes

        for media in problem.media where mediaToDeleteIDs.contains(media.id) {
            ImageStorageService.delete(at: media.url)
            context.delete(media)
        }

        do {
            for image in newImages {
                guard let data = image.jpegData(compressionQuality: 0.8) else { continue }
                let url = try ImageStorageService.save(data)
                let media = Media(url: url, type: .photo)
                context.insert(media)
                problem.media.append(media)
            }
            for url in newVideoURLs {
                let media = Media(url: url, type: .video)
                context.insert(media)
                problem.media.append(media)
            }
            try context.save()
            return true
        } catch {
            isSaveFailedAlertShowing = true
            return false
        }
    }
}
