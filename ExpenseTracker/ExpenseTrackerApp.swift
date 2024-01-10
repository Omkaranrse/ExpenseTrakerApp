//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 04/01/24.
//

import SwiftUI
import WidgetKit

@main
struct ExpenseTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear{
                    WidgetCenter.shared.reloadAllTimelines()
                }
        }
        .modelContainer(for: [Transaction.self])
    }
}
