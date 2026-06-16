import SwiftUI
import SwiftData
import Charts

struct GrowthView: View {
    @Query(sort: \DailyRecord.date) private var dailyRecords: [DailyRecord]
    @State private var viewModel = GrowthViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if dailyRecords.isEmpty {
                    emptyStateView
                } else {
                    statisticsScrollView
                }
            }
            .navigationTitle("성장 기록")
        }
        .onAppear { viewModel.update(records: dailyRecords) }
        .onChange(of: dailyRecords) { _, records in viewModel.update(records: records) }
    }

    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 52))
                .foregroundStyle(Color.App.primary.opacity(0.5))
            Text("기록이 없어요")
                .font(.App.subtitle)
                .foregroundStyle(Color.App.textPrimary)
            Text("클라이밍 기록을 추가하면 통계를 확인할 수 있어요.")
                .font(.App.body)
                .foregroundStyle(Color.App.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)
        }
    }

    private var statisticsScrollView: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                growthTrendSection
                monthlyRecordSection
                weeklyFrequencySection
                gradeSuccessSection
            }
            .padding(AppSpacing.md)
        }
    }

    private var growthTrendSection: some View {
        StatCard(title: "성장 추이") {
            if viewModel.statistics.monthlySuccessRates.isEmpty {
                emptyDataView
            } else {
                Chart(viewModel.statistics.monthlySuccessRates) { item in
                    LineMark(
                        x: .value("월", item.label),
                        y: .value("성공률", item.successRate * 100)
                    )
                    .foregroundStyle(Color.App.primary)
                    .interpolationMethod(.catmullRom)
                    PointMark(
                        x: .value("월", item.label),
                        y: .value("성공률", item.successRate * 100)
                    )
                    .foregroundStyle(Color.App.primary)
                    .symbolSize(36)
                }
                .chartYScale(domain: 0...100)
                .chartYAxis {
                    AxisMarks(values: [0, 25, 50, 75, 100]) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let v = value.as(Int.self) { Text("\(v)%") }
                        }
                    }
                }
                .frame(height: 180)
            }
        }
    }

    private var monthlyRecordSection: some View {
        StatCard(title: "월별 기록") {
            if viewModel.statistics.monthlyRecords.isEmpty {
                emptyDataView
            } else {
                Chart(viewModel.statistics.monthlyRecords) { item in
                    BarMark(
                        x: .value("월", item.label),
                        y: .value("횟수", item.count)
                    )
                    .foregroundStyle(Color.App.primary)
                    .cornerRadius(4)
                }
                .chartYAxis {
                    AxisMarks(values: .automatic(desiredCount: 4))
                }
                .frame(height: 180)
            }
        }
    }

    private var weeklyFrequencySection: some View {
        StatCard(title: "주간 운동 빈도") {
            if viewModel.statistics.weeklyFrequencies.isEmpty {
                emptyDataView
            } else {
                Chart(viewModel.statistics.weeklyFrequencies) { item in
                    BarMark(
                        x: .value("주", item.label),
                        y: .value("일수", item.sessionCount)
                    )
                    .foregroundStyle(Color.App.success)
                    .cornerRadius(4)
                }
                .chartYScale(domain: 0...7)
                .chartYAxis {
                    AxisMarks(values: [0, 2, 4, 6, 7])
                }
                .frame(height: 180)
            }
        }
    }

    private var gradeSuccessSection: some View {
        StatCard(title: "난이도별 성공률") {
            if viewModel.statistics.gradeSuccessRates.isEmpty {
                emptyDataView
            } else {
                VStack(spacing: AppSpacing.md) {
                    ForEach(viewModel.statistics.gradeSuccessRates) { item in
                        gradeRow(item)
                    }
                }
            }
        }
    }

    private func gradeRow(_ item: GradeSuccessData) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            HStack {
                Text(item.grade)
                    .font(.App.caption)
                    .foregroundStyle(.white)
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, AppSpacing.xs)
                    .background(Color.App.grade(item.grade))
                    .clipShape(Capsule())
                Spacer()
                Text("\(item.completed)/\(item.total)  \(Int(item.successRate * 100))%")
                    .font(.App.caption)
                    .foregroundStyle(Color.App.textSecondary)
                    .monospacedDigit()
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.App.textSecondary.opacity(0.15))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.App.grade(item.grade))
                        .frame(width: geo.size.width * item.successRate)
                }
            }
            .frame(height: 8)
        }
    }

    private var emptyDataView: some View {
        Text("데이터가 없어요")
            .font(.App.caption)
            .foregroundStyle(Color.App.textSecondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, AppSpacing.sm)
    }
}

private struct StatCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(title)
                .font(.App.subtitle)
                .foregroundStyle(Color.App.textPrimary)
            content
        }
        .padding(AppSpacing.md)
        .background(Color.App.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    GrowthView()
        .modelContainer(for: [DailyRecord.self, ClimbingGym.self, ProblemRecord.self, Media.self], inMemory: true)
}
