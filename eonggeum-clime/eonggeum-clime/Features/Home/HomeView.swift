import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var isShowingCreateRecord = false

    var body: some View {
        NavigationStack {
            Text("홈")
                .navigationTitle("엉금엉금")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            isShowingCreateRecord = true
                        } label: {
                            Image(systemName: "plus")
                                .foregroundStyle(Color.App.primary)
                        }
                    }
                }
                .sheet(isPresented: $isShowingCreateRecord) {
                    CreateRecordView()
                }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [DailyRecord.self, ClimbingGym.self], inMemory: true)
}
