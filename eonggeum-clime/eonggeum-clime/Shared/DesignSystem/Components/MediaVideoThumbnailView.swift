import SwiftUI
import AVKit

struct MediaVideoThumbnailView: View {
    let url: URL
    @State private var thumbnail: UIImage?
    @State private var isPlayerPresented = false

    var body: some View {
        ZStack {
            Group {
                if let thumbnail {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFill()
                } else {
                    Color.App.surface
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Image(systemName: "play.circle.fill")
                .font(.title)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, Color.black.opacity(0.5))
        }
        .onTapGesture {
            isPlayerPresented = true
        }
        .task(id: url) {
            thumbnail = await generateThumbnail()
        }
        .fullScreenCover(isPresented: $isPlayerPresented) {
            VideoPlayerSheet(url: url)
        }
    }

    private func generateThumbnail() async -> UIImage? {
        await Task.detached(priority: .utility) {
            let asset = AVAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            generator.maximumSize = CGSize(width: 128, height: 128)
            let time = CMTime(seconds: 0, preferredTimescale: 600)
            guard let cgImage = try? generator.copyCGImage(at: time, actualTime: nil) else { return nil }
            return UIImage(cgImage: cgImage)
        }.value
    }
}

private struct VideoPlayerSheet: View {
    let url: URL
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VideoPlayer(player: AVPlayer(url: url))
                .ignoresSafeArea()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, Color.black.opacity(0.6))
                    .padding()
            }
        }
    }
}
