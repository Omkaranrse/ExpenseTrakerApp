//
//  TransactionCardView.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 06/01/24.
//

import SwiftUI

struct TransactionCardView: View {
    
    @Environment(\.modelContext) private var context
    @State var viewOffset: CGFloat = 2
    @State var showRemove = false
    @State var removeRow = false
    
    let baseOffset: CGFloat = -2
    let deleteOffset: CGFloat = -40
    let animationDuration: TimeInterval = 0.3
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
            .onEnded { value in
                if value.translation.width < 0 { // Drag towards left
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        viewOffset = deleteOffset
                        showRemove = true
                    }
                } else if value.translation.width > 0 { // Drag towards right
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        viewOffset = baseOffset
                        showRemove = false
                    }
                }
            }
    }
    
    var transaction: Transaction
    var showCategory: Bool = false
    
    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                Text("\(String(transaction.title.prefix(1)))")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 45, height: 45)
                    .background(transaction.color.gradient, in: .circle)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.title)
                        .foregroundStyle(Color.primary)
                    
                    Text(transaction.remark)
                        .font(.caption)
                        .foregroundStyle(Color.primary.secondary)
                    
                    Text("Date: \(format(date: transaction.dateAdded, formate: "dd MMM yy"))")
                        .font(.caption2)
                        .foregroundStyle(Color.gray)
                    
                    if showCategory {
                        Text(transaction.category)
                            .font(.caption2)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .foregroundStyle(.white)
                            .background(transaction.category == Category.income.rawValue ? Color.green : Color.red, in: .capsule)
                    }
                }
                .lineLimit(1)
                .hSpacing(.leading)
                
                Text(currencyString(transaction.amount, allowedDigits: 0))
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.background, in: .rect(cornerRadius: 10))
            .offset(x: viewOffset)
            .gesture(dragGesture)
            .overlay(
                HStack {
                    Spacer()
                    Button {
                        deleteRow()
                    } label: {
                        Image(systemName: "multiply")
                            .font(.system(size: 25, weight: .semibold))
                    }
                    .buttonStyle(.plain)
                    .opacity(showRemove ? 1 : 0)
                    .opacity(removeRow ? 0 : 1)
                    .offset(x: 48)
                    .frame(width: 32, height: 32)
                    
                    Delete(isDeleting: $removeRow)
                        .frame(width: 32, height: 32)
                        .opacity(removeRow ? 1 : 0)
                }
                .zIndex(4)
            )
            .overlay(
                EmitterView()
                    .opacity(removeRow ? 1 : 0)
            )
        }
    }
    
    func deleteRow() {
        withAnimation(.default) {
            removeRow = true
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
            withAnimation(.easeOut(duration: animationDuration)) {
                viewOffset = -UIScreen.main.bounds.width
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 2.5, repeats: false) { _ in
            delete()
        }
    }
    
    func delete() {
        context.delete(transaction)
    }
    
    func format(date: Date, formate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        return dateFormatter.string(from: date)
    }
}



