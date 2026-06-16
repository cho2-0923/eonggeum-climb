//
//  eonggeum_climeApp.swift
//  eonggeum-clime
//
//  Created by Cho YeonJi on 5/24/26.
//

import SwiftUI
import SwiftData

@main
struct eonggeum_climeApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("홈", systemImage: "house.fill") {
                    HomeView()
                }
                Tab("성장 기록", systemImage: "chart.line.uptrend.xyaxis") {
                    GrowthView()
                }
            }
            .tint(Color.App.primary)
        }
        .modelContainer(for: [
            DailyRecord.self,
            ClimbingGym.self,
            ProblemRecord.self,
            Media.self
        ])
    }
}
