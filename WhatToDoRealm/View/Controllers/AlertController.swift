//
//  AlertController.swift
//  WhatToDoRealm
//
//  Created by Temur Juraev on 12.05.2022.
//

import UIKit

class AlertController: UIAlertController {
    
    var doneButton = "Save"

    
    static func createAlert(withTitle title: String, andMessage message: String) -> AlertController {
        AlertController(title: title, message: message, preferredStyle: .alert)
    }
    //MARK: - Action для CategoryVC
    func action(with categoryList: CategoryList?,  completion: @escaping (String) -> Void) {
        
        if categoryList != nil {doneButton = "Update"}
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else {return}
            guard !newValue.isEmpty else {return}
            completion(newValue)
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.placeholder = "Category Name"
            textField.text = categoryList?.name
           
        }
    }
    //MARK: - Action для TasksVC
    func action(with task: Task?, completion: @escaping(String, String) -> Void) {
        let title = task != nil ? "Update" : "Save"
        
        let saveAction = UIAlertAction(title: title, style: .default) { _ in
            guard let newTask = self.textFields?.first?.text else {return}
            guard !newTask.isEmpty else {return}
            
            if let note = self.textFields?.last?.text, !note.isEmpty {
                completion(newTask, note)
            } else {
                completion(newTask, "")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.placeholder = "New task"
            textField.text = task?.name
        }
        addTextField { textField in
            textField.placeholder = "Note"
            textField.text = task?.note
        }
       
    }
    }

    
