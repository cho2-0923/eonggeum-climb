import SwiftUI

struct ProblemRecordListView: View {
    let problems: [ProblemRecord]
    let onAddProblem: () -> Void
    let onEdit: (ProblemRecord) -> Void
    let onDelete: (ProblemRecord) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("문제 기록")
                    .font(.App.subtitle)
                    .foregroundStyle(Color.App.textPrimary)
                Spacer()
                Button(action: onAddProblem) {
                    Label("추가", systemImage: "plus.circle.fill")
                        .font(.App.caption)
                        .foregroundStyle(Color.App.primary)
                }
            }

            if problems.isEmpty {
                VStack(spacing: AppSpacing.sm) {
                    Image(systemName: "list.bullet.clipboard")
                        .font(.system(size: 36))
                        .foregroundStyle(Color.App.textSecondary.opacity(0.5))
                    Text("아직 추가된 문제 기록이 없어요.")
                        .font(.App.body)
                        .foregroundStyle(Color.App.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.xl)
            } else {
                ForEach(problems) { problem in
                    ProblemRecordCard(problem: problem)
                        .contextMenu {
                            Button { onEdit(problem) } label: {
                                Label("수정", systemImage: "pencil")
                            }
                            Button(role: .destructive) { onDelete(problem) } label: {
                                Label("삭제", systemImage: "trash")
                            }
                        }
                }
            }
        }
    }
}
