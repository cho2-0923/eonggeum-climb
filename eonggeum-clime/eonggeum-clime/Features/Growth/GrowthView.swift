import SwiftUI

struct GrowthView: View {
    @StateObject private var viewModel = GrowthViewModel()

    var body: some View {
        Text("성장 그래프")
    }
}

#Preview {
    GrowthView()
}
