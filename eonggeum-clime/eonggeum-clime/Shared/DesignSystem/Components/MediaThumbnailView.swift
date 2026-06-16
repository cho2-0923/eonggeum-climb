import SwiftUI

struct MediaThumbnailView: View {
    let url: URL
    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.App.surface
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundStyle(Color.App.textSecondary)
                    )
            }
        }
        .frame(width: 64, height: 64)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .task(id: url) {
            image = await loadImage()
        }
    }

    private func loadImage() async -> UIImage? {
        await Task.detached(priority: .utility) {
            guard let data = try? Data(contentsOf: url) else { return nil }
            return UIImage(data: data)
        }.value
    }
}
