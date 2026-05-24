import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false
    var isFullWidth: Bool = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.App.button)
                .foregroundStyle(isDisabled ? Color.App.primary.opacity(0.4) : Color.App.primary)
                .padding(.vertical, AppSpacing.sm)
                .padding(.horizontal, AppSpacing.lg)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .background(Color.App.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isDisabled ? Color.App.primary.opacity(0.4) : Color.App.primary, lineWidth: 1.5)
                )
        }
        .disabled(isDisabled)
    }
}

#Preview {
    VStack(spacing: AppSpacing.md) {
        SecondaryButton(title: "취소", action: {})
        SecondaryButton(title: "비활성화", action: {}, isDisabled: true)
        SecondaryButton(title: "전체 너비", action: {}, isFullWidth: true)
    }
    .padding()
}
