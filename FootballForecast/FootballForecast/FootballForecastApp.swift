//
//  FootballForecastApp.swift
//  FootballForecast
//
//  Created by BRIAN FALLON on 2/3/24.
//

import SwiftUI
import SwiftData

@main
struct FootballForecastApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ForecastItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            StadiumScreen()
        }
        .modelContainer(sharedModelContainer)
    }
}
