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
                        viewModel.save(context: modelContext)
                        dismiss()
                    }
                    .font(.App.button)
                    .foregroundStyle(viewModel.canSave ? Color.App.primary : Color.App.textSecondary)
                    .disabled(!viewModel.canSave)
                }
            }
        }
    }
}

#Preview {
    CreateRecordView()
        .modelContainer(for: [DailyRecord.self, ClimbingGym.self], inMemory: true)
}
