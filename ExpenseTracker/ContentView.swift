//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 04/01/24.
//

import SwiftUI

struct ContentView: View {
    
    //Intro Visibility status
    @AppStorage("isFirstTime") private var isFirstTime : Bool = true
    
    //App Lock Properties
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled : Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground : Bool = false

    
    // Active Tab
    @State private var activeTab : Tab = .recents
    
    var body: some View {
        
        LockView(lockType: .biometric, lockPin: "", isEnabled: isAppLockEnabled, lockWhenAppGoesBackground: lockWhenAppGoesBackground) {
            TabView(selection: $activeTab, content:  {
                
                Recents()
                    .tabItem { Tab.recents.tabContent }
                    .tag(Tab.recents)
                
                Search()
                    .tabItem { Tab.search.tabContent }
                    .tag(Tab.search)

                Charts()
                    .tabItem { Tab.charts.tabContent }
                    .tag(Tab.charts)

                Settings()
                    .tabItem { Tab.settings.tabContent }
                    .tag(Tab.settings)

            })
            .tint(appTint)
            .sheet(isPresented: $isFirstTime, content: {
                IntroScreen()
                    .interactiveDismissDisabled()
            })
        }
    }
}

#Preview {
    ContentView()
}
