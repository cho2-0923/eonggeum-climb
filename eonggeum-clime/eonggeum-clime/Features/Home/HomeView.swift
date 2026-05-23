import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            Text("홈")
                .navigationTitle("엉금엉금")
        }
    }
}

#Preview {
    HomeView()
}
