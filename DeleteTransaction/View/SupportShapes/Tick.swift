//
//  Tick.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 10/01/24.
//

import SwiftUI

struct Tick: Shape {
    // MARK: - variables
    let scaleFactor: CGFloat
    
    // MARK: - functions
    
    // Required function when conforming to shape protocol
    // returns path
    func path(in rect: CGRect) -> Path {
        
        let cX = rect.midX + 4
        let cY = rect.midY - 3
        
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.move(to: CGPoint(
            x: cX - (42 * scaleFactor),
            y: cY - (4 * scaleFactor)
        ))
        path.addLine(to: CGPoint(
            x: cX - (scaleFactor * 18),
            y: cY + (scaleFactor * 28)
        ))
        path.addLine(to: CGPoint(
            x: cX + (scaleFactor * 40),
            y: cY - (scaleFactor * 36)
        ))
        
        return path
    }
}

#Preview {
    Tick(scaleFactor: 1)
        .stroke(lineWidth: 5)
}

