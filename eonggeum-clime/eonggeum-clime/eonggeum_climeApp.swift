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
            HomeView()
        }
        .modelContainer(for: [
            DailyRecord.self,
            ClimbingGym.self,
            ProblemRecord.self,
            Media.self
        ])
    }
}
