//
//  TaskRowView.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 10/01/24.
//

import SwiftUI

struct TaskRowView: View {
    
    var transaction: Transaction
    var showCategory : Bool = false

    // MARK: - Variables
    @EnvironmentObject var taskManager: TaskManager
    @ObservedObject var task: TaskModel
    @State var viewOffset: CGFloat = 2
    @State var showRemove = false
    @State var removeRow = false
    
    let baseOffset: CGFloat = -2
    let deleteOffset: CGFloat = -40
    let animationDuration: TimeInterval = 0.3
    
    let dragLimit: CGFloat = 30
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
            .onEnded { value in
                if value.translation.width < 0 { // Drag towards left
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        viewOffset = deleteOffset
                        showRemove = true
                    }
                } else if value.translation.width > 0 { // Drag towards right
                    withAnimation(.easeInOut (duration: animationDuration)){
                        viewOffset = baseOffset
                        showRemove = false
                    }
                }
            }
    }
    
    // MARK: - Views
    var body: some View {
        ZStack(alignment: .leading) {
            //view container ZStack
            ZStack{
                Color.background
                
                // Layer #1 :- Black Rectangle outline
                RoundedRectangle(cornerRadius: 8)
                    .offset(x: 3, y: 5)
                
                // Layer #2 :- Black Rectangle outline
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.background)
                
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
                        
                        Text(format(date: transaction.dateAdded, formate: "dd MMM yy"))
                            .font(.caption2)
                            .foregroundStyle(Color.gray)
                        
                        if showCategory {
                            Text(transaction.category)
                                .font(.caption2)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .foregroundStyle(.white)
                                .background(transaction.category == Category.income.rawValue ? Color.green.gradient : Color.red.gradient, in: .capsule)
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

                //Stroke outline for the view
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
            }
            .offset(x: viewOffset)// offset to move the view while deletion is in progress
            
            // HStack to contain the Remove Task Button, Deleting Line View & the Particles
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
            
            // Particle Emitter View, show when row is being removed
            EmitterView()
                .opacity(removeRow ? 1 : 0)
        }
        .onAppear(){
            self.viewOffset = 2
        }
        //apply drag gesture to the outer modet zstack
        .gesture(dragGesture)
    }
    
    //MARK: - Function
    func deleteRow(){
        //mark row for removal
        withAnimation(.default){
            removeRow = true
        }
        
        //time the line deleting animation and then chain the movement through the offset
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
            // set the view offset to negative width to move the view towards the left
            withAnimation(.easeOut(duration: animationDuration)){
                viewOffset = -UIScreen.main.bounds.width
            }
        }
        
        //Time the delete function of the VM and removes the task after animation is completed
        Timer.scheduledTimer(withTimeInterval: animationDuration * 2.5, repeats: false) { _ in
            delete()
        }
    }
    
    func delete(){
        transaction.deleteTask(task: task)
    }
}

        
#Preview {
    TransactionCardView(transaction: Transaction.init(title: "omkar", remark: "jjsjs", amount: 1999, dateAdded: .now, category: .expenses, tintColor: .init(color: "red", value: .red)))
}


