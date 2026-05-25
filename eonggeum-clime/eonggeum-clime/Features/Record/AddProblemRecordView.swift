import SwiftUI
import SwiftData

struct AddProblemRecordView: View {
    let dailyRecord: DailyRecord
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = AddProblemRecordViewModel()

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
            }
            .navigationTitle("문제 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                        .foregroundStyle(Color.App.textSecondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        if viewModel.save(context: modelContext, into: dailyRecord) != nil {
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
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DailyRecord.self, configurations: config)
    let record = DailyRecord(date: .now)
    container.mainContext.insert(record)
    return AddProblemRecordView(dailyRecord: record)
        .modelContainer(container)
}
