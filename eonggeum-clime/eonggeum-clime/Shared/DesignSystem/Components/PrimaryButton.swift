import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false
    var isFullWidth: Bool = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.App.button)
                .foregroundStyle(.white)
                .padding(.vertical, AppSpacing.sm)
                .padding(.horizontal, AppSpacing.lg)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .background(isDisabled ? Color.App.primary.opacity(0.4) : Color.App.primary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(isDisabled)
    }
}

#Preview {
    VStack(spacing: AppSpacing.md) {
        PrimaryButton(title: "기록 추가", action: {})
        PrimaryButton(title: "비활성화", action: {}, isDisabled: true)
        PrimaryButton(title: "전체 너비", action: {}, isFullWidth: true)
    }
    .padding()
}
