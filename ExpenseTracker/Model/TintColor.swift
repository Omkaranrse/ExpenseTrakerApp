//
//  TintColor.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 05/01/24.
//

import SwiftUI

//Custom Tint Color for Transaction Row
struct TintColor : Identifiable {
    let id: UUID = .init()
    var color : String
    var value : Color
}

var tints : [TintColor] = [
    .init(color: "Red", value: .red),
    .init(color: "Blue", value: .blue),
    .init(color: "Pink", value: .pink),
    .init(color: "Purple", value: .purple),
    .init(color: "orange", value: .orange),
    .init(color: "Yellow", value: .yellow)
]

