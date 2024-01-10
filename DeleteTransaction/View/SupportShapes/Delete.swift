//
//  Delete.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 10/01/24.
//

import SwiftUI

struct Delete: View {
    // MARK: - variables
    @Binding var isDeleting : Bool
    let width : CGFloat = UIScreen.main.bounds.width
    
    // MARK: - views
    var body: some View {
        ZStack {
            // Line 1
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.label.opacity(0.5))
            
            // Line 1
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.label)
                .offset(x: 2, y: 3.5)
        }
        //set the frame width & height
        .frame(width: isDeleting ? width : 40, height: 2)
        //set the offset when deletion is in progress
        .offset(x: isDeleting ? -width * 1.5 : -12)
        .animation(.easeInOut(duration: 0.8), value: isDeleting)
        .frame(width: 44, height: 44)
    }
}

#Preview {
    Delete(isDeleting: .constant(false))
}

