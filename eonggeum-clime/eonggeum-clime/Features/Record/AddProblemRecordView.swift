import SwiftUI

struct AddProblemRecordView: View {
    let dailyRecord: DailyRecord
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "준비 중이에요",
                systemImage: "hammer.fill",
                description: Text("문제 기록 추가 기능은 곧 제공될 예정이에요.")
            )
            .navigationTitle("문제 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("닫기") { dismiss() }
                        .foregroundStyle(Color.App.textSecondary)
                }
            }
        }
    }
}
