import SwiftUI

struct ProblemRecordCard: View {
    let problem: ProblemRecord

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Text(problem.grade)
                .font(.App.subtitle)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(Color.App.primary)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(problem.isCompleted ? "완등" : "도전 중")
                    .font(.App.body)
                    .foregroundStyle(problem.isCompleted ? Color.App.success : Color.App.warning)
                Text("시도 \(problem.attempts)회")
                    .font(.App.caption)
                    .foregroundStyle(Color.App.textSecondary)
            }

            Spacer()

            Image(systemName: problem.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(problem.isCompleted ? Color.App.success : Color.App.textSecondary)
        }
        .padding(AppSpacing.md)
        .background(Color.App.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    VStack(spacing: AppSpacing.sm) {
        ProblemRecordCard(problem: ProblemRecord(grade: "V3", isCompleted: true, attempts: 3))
        ProblemRecordCard(problem: ProblemRecord(grade: "V5", isCompleted: false, attempts: 7))
    }
    .padding()
}
