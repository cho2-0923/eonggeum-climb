import SwiftUI
import SwiftData

struct EditDailyRecordView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: EditDailyRecordViewModel

    init(record: DailyRecord) {
        _viewModel = State(initialValue: EditDailyRecordViewModel(record: record))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("암장", selection: $viewModel.selectedGymName) {
                        Text("선택 안 함").tag("")
                        ForEach(viewModel.gymOptions, id: \.self) { gym in
                            Text(gym).tag(gym)
                        }
                    }
                } header: {
                    Text("암장")
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
            }
            .navigationTitle("기록 수정")
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
                    .foregroundStyle(Color.App.primary)
                }
            }
            .alert("저장 실패", isPresented: $viewModel.isSaveFailedAlertShowing) {
                Button("확인", role: .cancel) {}
            } message: {
                Text("기록을 저장하는 데 실패했어요. 다시 시도해주세요.")
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DailyRecord.self, configurations: config)
    let record = DailyRecord(date: .now)
    container.mainContext.insert(record)
    return EditDailyRecordView(record: record)
        .modelContainer(container)
}
