import Foundation
import PhotosUI
import SwiftUI
import SwiftData

@Observable
final class AddProblemRecordViewModel {
    var grade: String = ""
    var isCompleted: Bool = false
    var attempts: Int = 1
    var notes: String = ""
    var isSaveFailedAlertShowing = false
    var isImageLoadFailedAlertShowing = false
    var selectedItems: [PhotosPickerItem] = []
    var selectedImages: [UIImage] = []

    var canSave: Bool {
        !grade.trimmingCharacters(in: .whitespaces).isEmpty
    }

    @MainActor
    func loadImages(from items: [PhotosPickerItem]) async {
        selectedImages = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImages.append(image)
            } else {
                isImageLoadFailedAlertShowing = true
            }
        }
    }

    @discardableResult
    func save(context: ModelContext, into dailyRecord: DailyRecord) -> ProblemRecord? {
        guard canSave else { return nil }
        let record = ProblemRecord(
            grade: grade.trimmingCharacters(in: .whitespaces),
            isCompleted: isCompleted,
            attempts: attempts,
            notes: notes.isEmpty ? nil : notes
        )
        do {
            context.insert(record)
            dailyRecord.problems.append(record)
            for image in selectedImages {
                guard let data = image.jpegData(compressionQuality: 0.8) else { continue }
                let url = try ImageStorageService.save(data)
                let media = Media(url: url, type: .photo)
                context.insert(media)
                record.media.append(media)
            }
            try context.save()
            return record
        } catch {
            isSaveFailedAlertShowing = true
            return nil
        }
    }
}
