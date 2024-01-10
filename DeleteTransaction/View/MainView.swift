//
//  MainView.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 10/01/24.
//

import SwiftUI

struct MainView: View {
    
    // MARK: - variables
    @StateObject var taskManger : TaskManager = TaskManager()
    @State var counter = 1
    
    var transaction: Transaction

    
    // MARK: - views
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            Color.background
                .ignoresSafeArea(.all)
            
            //ScrollView
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading){
                    HStack{
                        Text("Tasks")
                            .font(.system(size: 30, weight: .bold, design: .monospaced))
                        
                        Spacer()
                        
                        Button(action: {
                            //add task
                            self.taskManger.addTask(task: TaskModel(taskName: "Task #\(counter)", isTaskCompleted: false))
                            counter += 1
                            
                        }, label: {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .semibold))
                        })
                    }
                    
                    
                    // Tasks VStack
                    VStack(spacing: 20){
                        ForEach(taskManger.tasks, id: \.self.taskID){ task in
                            TaskRowView(transaction: transaction, task: task)
                                .environmentObject(taskManger)
                        }
                    }
                    .padding(.top, 32)
                }
                .padding(24)
            }
        }
    }
}

#Preview {
    MainView(transaction: Transaction(title: "omkar", remark: "lajn", amount: 66636, dateAdded: .now, category: .expenses, tintColor: .init(color: "red", value: .red)))
}
