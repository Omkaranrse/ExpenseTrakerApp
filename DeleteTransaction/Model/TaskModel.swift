//
//  Task.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 10/01/24.
//

import Foundation

class TaskModel : ObservableObject {
    // MARK: - variables
    @Published var taskName: String
    @Published var isTaskCompleted2: Bool
    
    let taskID : String
    
    // MARK: - Inits
    init(taskName: String, isTaskCompleted: Bool) {
        self.taskName = taskName
        self.isTaskCompleted2 = isTaskCompleted
        self.taskID = UUID().uuidString
    }
    
    // MARK: - Functions
    
    // Toggle the status of the isTaskCompleted Variable
    func toogleStatus() {
        self.isTaskCompleted2.toggle()
    }
}
