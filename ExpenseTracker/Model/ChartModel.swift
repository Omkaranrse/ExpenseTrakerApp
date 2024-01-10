//
//  ChartModel.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 09/01/24.
//

import SwiftUI

struct ChartGroup : Identifiable {
    let id : UUID = .init()
    var date : Date
    var totalIncome : Double
    var totalExpense : Double
    var categories : [ChartCategory]
}

struct ChartCategory : Identifiable {
    let id : UUID = .init()
    var totalValue : Double
    var category : Category
}
