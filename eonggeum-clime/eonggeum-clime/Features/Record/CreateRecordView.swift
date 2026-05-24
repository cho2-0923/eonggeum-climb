import SwiftUI
import SwiftData

struct CreateRecordView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = CreateRecordViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker(
                        "날짜",
                        selection: $viewModel.selectedDate,
                        in: ...Date.now,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .tint(Color.App.primary)
                } header: {
                    Text("날짜 선택")
                        .font(.App.caption)
                        .foregroundStyle(Color.App.textSecondary)
                }

                Section {
                    Picker("클라이밍장", selection: $viewModel.selectedGymName) {
                        Text("선택 안 함").tag("")
                        ForEach(viewModel.gymOptions, id: \.self) { name in
                            Text(name).tag(name)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Color.App.primary)
                } header: {
                    Text("클라이밍장 (선택)")
                        .font(.App.caption)
                        .foregroundStyle(Color.App.textSecondary)
                }
            }
            .navigationTitle("하루 기록 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                        .foregroundStyle(Color.App.textSecondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        if viewModel.save(context: modelContext) != nil {
                            dismiss()
                        }
                    }
                    .font(.App.button)
                    .foregroundStyle(viewModel.canSave ? Color.App.primary : Color.App.textSecondary)
                    .disabled(!viewModel.canSave)
                }
            }
            .alert("이미 기록이 있어요", isPresented: $viewModel.isDuplicateDateAlertShowing) {
                Button("확인", role: .cancel) {}
            } message: {
                Text("선택한 날짜에 이미 기록이 있어요. 다른 날짜를 선택해주세요.")
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
    CreateRecordView()
        .modelContainer(for: [DailyRecord.self, ClimbingGym.self], inMemory: true)
}
