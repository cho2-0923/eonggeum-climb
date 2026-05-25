import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = HomeViewModel()
    @State private var isShowingCreateRecord = false
    @State private var isShowingAddProblem = false
    @State private var isShowingEditDailyRecord = false
    @State private var selectedProblemForEdit: ProblemRecord? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    dateNavigatorView

                    if let record = viewModel.dailyRecord {
                        recordContentView(record: record)
                    } else {
                        emptyStateView
                    }
                }
                .padding(AppSpacing.md)
            }
            .navigationTitle("엉금엉금")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if viewModel.dailyRecord != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isShowingEditDailyRecord = true
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundStyle(Color.App.primary)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchRecord(context: modelContext)
        }
        .onChange(of: viewModel.selectedDate) {
            viewModel.fetchRecord(context: modelContext)
        }
        .onChange(of: isShowingCreateRecord) {
            if !isShowingCreateRecord {
                viewModel.fetchRecord(context: modelContext)
            }
        }
        .sheet(isPresented: $isShowingCreateRecord) {
            CreateRecordView()
        }
        .sheet(isPresented: $isShowingAddProblem) {
            if let record = viewModel.dailyRecord {
                AddProblemRecordView(dailyRecord: record)
            }
        }
        .sheet(isPresented: $isShowingEditDailyRecord) {
            if let record = viewModel.dailyRecord {
                EditDailyRecordView(record: record)
            }
        }
        .sheet(item: $selectedProblemForEdit) { problem in
            EditProblemRecordView(problem: problem)
        }
    }

    private var dateNavigatorView: some View {
        HStack {
            Button(action: viewModel.goToPreviousDay) {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color.App.primary)
                    .padding(AppSpacing.sm)
            }

            Spacer()

            Text(viewModel.selectedDate.formatted(.dateTime.year().month(.wide).day()))
                .font(.App.subtitle)
                .foregroundStyle(Color.App.textPrimary)

            Spacer()

            Button(action: viewModel.goToNextDay) {
                Image(systemName: "chevron.right")
                    .foregroundStyle(viewModel.isNextDayAllowed ? Color.App.primary : Color.App.textSecondary)
                    .padding(AppSpacing.sm)
            }
            .disabled(!viewModel.isNextDayAllowed)
        }
        .padding(.vertical, AppSpacing.xs)
        .background(Color.App.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func recordContentView(record: DailyRecord) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            if let gym = record.gym {
                Label(gym.name, systemImage: "mappin.circle.fill")
                    .font(.App.body)
                    .foregroundStyle(Color.App.textSecondary)
            }

            ProblemRecordListView(
                problems: record.problems,
                onAddProblem: { isShowingAddProblem = true },
                onEdit: { selectedProblemForEdit = $0 }
            )
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "figure.climbing")
                .font(.system(size: 52))
                .foregroundStyle(Color.App.primary.opacity(0.5))
                .padding(.top, AppSpacing.lg)

            Text("이 날의 기록이 없어요")
                .font(.App.subtitle)
                .foregroundStyle(Color.App.textPrimary)

            Text("클라이밍 세션을 시작해볼까요?")
                .font(.App.body)
                .foregroundStyle(Color.App.textSecondary)

            PrimaryButton(title: "기록 추가", action: {
                isShowingCreateRecord = true
            }, isFullWidth: true)
            .padding(.top, AppSpacing.xs)
            .padding(.bottom, AppSpacing.lg)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, AppSpacing.xl)
        .background(Color.App.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [DailyRecord.self, ClimbingGym.self, ProblemRecord.self, Media.self], inMemory: true)
}
