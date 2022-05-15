//
//  TasksViewController.swift
//  WhatToDoRealm
//
//  Created by Temur Juraev on 12.05.2022.
//

import RealmSwift

class TasksViewController: UITableViewController {
    
    var categoryList: CategoryList!
    
    private var currentTasks: Results<Task>!
    private var completedTasks: Results<Task>!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = categoryList.name
        
        currentTasks = categoryList.tasks.filter("isComplete = false")
        completedTasks = categoryList.tasks.filter("isComplete = true")
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed))
        addButton.tintColor = .white
        
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task", for: indexPath)
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        content.secondaryText = task.note
        cell.contentConfiguration = content
        return cell
    }
    
    @objc private func addButtonPressed() {
        showAlert()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }

    //MARK: - UITableView Delegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let tasks = indexPath.section == 0
        ? currentTasks[indexPath.row]
        : completedTasks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(tasks)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { _, _, isDone in
            self.showAlert(with: tasks) {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneTitle = indexPath.section == 0 ? "Done" : "Undone"
        
        let doneAction = UIContextualAction(style: .destructive, title: doneTitle) { _, _, isDone in
           
            StorageManager.shared.done(tasks)
            let indexPathForCurrentTask = IndexPath(row: self.currentTasks.count - 1, section: 0)
            let indexPathForCompletedTasks = IndexPath(row: self.completedTasks.count - 1, section: 1)
            let destionationIndexRow = indexPath.section == 0 ? indexPathForCompletedTasks : indexPathForCurrentTask
            tableView.moveRow(at: indexPath, to: destionationIndexRow)
            
            isDone(true)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
                                         
    }
}






extension TasksViewController {
    private func showAlert(with task: Task? = nil, completion: (() -> Void)? = nil) {
        
        let title = task != nil ? "Edit Task" : "New Task"
        
        let alert = AlertController.createAlert(withTitle: title, andMessage: "What do you want to do?")
        alert.action(with: task) { newValue, note in
            if let task = task, let completion = completion {
                StorageManager.shared.rename(task, to: newValue, withNote: note)
                completion()
            } else {
                self.saveTask(withName: newValue, andNote: note)

            }
            self.tableView.reloadData()
           
        }
        present(alert, animated: true)
        
    }
    
    private func saveTask(withName name: String, andNote note: String) {
        let task = Task(value: [name, note])
        StorageManager.shared.saveTask(task, to: categoryList)
        let rowIndex = IndexPath(row: currentTasks.firstIndex(of: task) ?? 0, section: 0)
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
}
