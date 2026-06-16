import SwiftUI
import SwiftData
import PhotosUI

struct EditProblemRecordView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: EditProblemRecordViewModel

    init(problem: ProblemRecord) {
        _viewModel = State(initialValue: EditProblemRecordViewModel(problem: problem))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("예: V3, 빨강, 초급", text: $viewModel.grade)
                        .autocorrectionDisabled()
                } header: {
                    Text("난이도")
                        .font(.App.caption)
                        .foregroundStyle(Color.App.textSecondary)
                }

                Section {
                    Toggle("완등", isOn: $viewModel.isCompleted)
                        .tint(Color.App.primary)
                    Stepper("시도 횟수: \(viewModel.attempts)회", value: $viewModel.attempts, in: 1...50)
                } header: {
                    Text("결과")
                        .font(.App.caption)
                        .foregroundStyle(Color.App.textSecondary)
                }

                Section {
                    TextField("메모를 입력하세요", text: $viewModel.notes, axis: .vertical)
                        .lineLimit(3...5)
                } header: {
                    Text("메모 (선택)")
                        .font(.App.caption)
                        .foregroundStyle(Color.App.textSecondary)
                }

                Section {
                    let existingPhotos = viewModel.existingMedia.filter { $0.type == .photo }
                    let hasPhotos = !existingPhotos.isEmpty || !viewModel.newImages.isEmpty
                    if hasPhotos {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppSpacing.sm) {
                                ForEach(existingPhotos) { media in
                                    ZStack(alignment: .topTrailing) {
                                        MediaThumbnailView(url: media.url)
                                        Button {
                                            viewModel.markForDeletion(media)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .symbolRenderingMode(.palette)
                                                .foregroundStyle(.white, Color.App.primary)
                                                .font(.system(size: 18))
                                        }
                                        .offset(x: 6, y: -6)
                                    }
                                }
                                ForEach(Array(viewModel.newImages.enumerated()), id: \.offset) { _, image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 64, height: 64)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets(top: AppSpacing.sm, leading: AppSpacing.md, bottom: AppSpacing.sm, trailing: AppSpacing.md))
                    }

                    PhotosPicker(
                        selection: $viewModel.selectedPhotoItems,
                        maxSelectionCount: 5,
                        matching: .images
                    ) {
                        Label("사진 추가", systemImage: "photo.badge.plus")
                    }
                    .onChange(of: viewModel.selectedPhotoItems) { _, items in
                        Task { await viewModel.loadImages(from: items) }
                    }
                } header: {
                    Text("사진 (선택)")
                        .font(.App.caption)
                        .foregroundStyle(Color.App.textSecondary)
                }

                Section {
                    let existingVideos = viewModel.existingMedia.filter { $0.type == .video }
                    let hasVideos = !existingVideos.isEmpty || !viewModel.newVideoURLs.isEmpty
                    if hasVideos {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppSpacing.sm) {
                                ForEach(existingVideos) { media in
                                    ZStack(alignment: .topTrailing) {
                                        MediaVideoThumbnailView(url: media.url)
                                        Button {
                                            viewModel.markForDeletion(media)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .symbolRenderingMode(.palette)
                                                .foregroundStyle(.white, Color.App.primary)
                                                .font(.system(size: 18))
                                        }
                                        .offset(x: 6, y: -6)
                                    }
                                }
                                ForEach(viewModel.newVideoURLs, id: \.absoluteString) { url in
                                    MediaVideoThumbnailView(url: url)
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets(top: AppSpacing.sm, leading: AppSpacing.md, bottom: AppSpacing.sm, trailing: AppSpacing.md))
                    }

                    PhotosPicker(
                        selection: $viewModel.selectedVideoItems,
                        maxSelectionCount: 3,
                        matching: .videos
                    ) {
                        Label("영상 추가", systemImage: "video.badge.plus")
                    }
                    .onChange(of: viewModel.selectedVideoItems) { _, items in
                        Task { await viewModel.loadVideos(from: items) }
                    }
                } header: {
                    Text("영상 (선택)")
                        .font(.App.caption)
                        .foregroundStyle(Color.App.textSecondary)
                }
            }
            .navigationTitle("문제 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                        .foregroundStyle(Color.App.textSecondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        if viewModel.save(context: modelContext) {
                            dismiss()
                        }
                    }
                    .font(.App.button)
                    .foregroundStyle(viewModel.canSave ? Color.App.primary : Color.App.textSecondary)
                    .disabled(!viewModel.canSave)
                }
            }
            .alert("저장 실패", isPresented: $viewModel.isSaveFailedAlertShowing) {
                Button("확인", role: .cancel) {}
            } message: {
                Text("문제 기록을 저장하는 데 실패했어요. 다시 시도해주세요.")
            }
            .alert("사진 불러오기 실패", isPresented: $viewModel.isImageLoadFailedAlertShowing) {
                Button("확인", role: .cancel) {}
            } message: {
                Text("일부 사진을 불러오지 못했어요. 다시 시도해주세요.")
            }
            .alert("영상 불러오기 실패", isPresented: $viewModel.isVideoLoadFailedAlertShowing) {
                Button("확인", role: .cancel) {}
            } message: {
                Text("일부 영상을 불러오지 못했어요. 다시 시도해주세요.")
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DailyRecord.self, configurations: config)
    let problem = ProblemRecord(grade: "V3", isCompleted: true, attempts: 3, notes: "발 홀드 집중")
    container.mainContext.insert(problem)
    return EditProblemRecordView(problem: problem)
        .modelContainer(container)
}
