//
//  LockConentView.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 07/01/24.
//

import SwiftUI

struct LockConentView: View {
    var body: some View {
        LockView(lockType: .number, lockPin: "1906", isEnabled: true) {
            VStack(spacing: 15){
                Text("hi")
            }
        }
    }
}

#Preview {
    LockConentView()
}
