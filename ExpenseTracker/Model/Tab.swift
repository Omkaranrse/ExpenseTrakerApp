//
//  Tab.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 05/01/24.
//

import SwiftUI

enum Tab : String {
    case recents = "recents"
    case search = "search"
    case charts = "charts"
    case settings = "settings"
    
    @ViewBuilder
    var tabContent : some View {
        switch self {
        case .recents:
            Image(systemName: "calendar")
            Text(self.rawValue)
        case .search:
            Image(systemName: "magnifyingglass")
            Text(self.rawValue)
        case .charts:
            Image(systemName: "chart.bar.xaxis")
            Text(self.rawValue)
        case .settings:
            Image(systemName: "gearshape")
            Text(self.rawValue)
        }
    }
}
