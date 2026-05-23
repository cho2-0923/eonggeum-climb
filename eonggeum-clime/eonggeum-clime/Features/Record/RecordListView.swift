import SwiftUI

struct RecordListView: View {
    @StateObject private var viewModel = RecordListViewModel()

    var body: some View {
        Text("기록 목록")
    }
}

#Preview {
    RecordListView()
}
