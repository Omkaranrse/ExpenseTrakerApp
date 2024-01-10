//
//  FileRandomiser.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 10/01/24.
//


import SwiftUI

enum Fill : String, CaseIterable {
    case blue
    case red
    case violet
    case orange
    case teal
    case yellow
}

struct FillRandomiser {
    static func getRandomFill() -> Fill {
        //generate a random integer between 0 & the Enum max count
        let randomValue = Int.random(in: 0 ..< Fill.allCases.count)
        return Fill.allCases[randomValue]
    }
}
