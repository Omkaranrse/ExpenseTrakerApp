//
//  TaskManager.swift
//  ExpenseTracker
//
//  Created by Omkar Anarse on 10/01/24.
//

import SwiftUI

// Task ViewModel
class TaskManager: ObservableObject {
    // MARK: - Variables
    @Published var tasks: [TaskModel] = []
    
    // MARK: - Init
    init() {
        //initialise default Tasks
        self.tasks = [
            TaskModel(taskName: "Task 1", isTaskCompleted: false)
        ]
    }
    //MARK: - Functions
    
    // Adds a Task to the Tasks Array
    func addTask(task: TaskModel) {
        withAnimation(.easeInOut(duration:0.25)) {
            self.tasks.append(task)
        }
    }
    
    // Removes a Task from the Tasks Array
    func deleteTask(task: TaskModel) {
        withAnimation(.easeInOut(duration: 0.25)) {
            self.tasks = tasks.filter { $0.taskID != task.taskID }
        }
    }
    
    //Toggle the status for a Particular task
    func toggleStatusForTask(task: TaskModel) {
        guard !tasks.isEmpty, let index = tasks.firstIndex(where: { $0.taskID == task.taskID }) else { return }
        self.tasks[index].toogleStatus()
    }
}
