//
//  StorageManager.swift
//  WhatToDoRealm
//
//  Created by Temur Juraev on 12.05.2022.
//

import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    //MARK: - Метод вызывается один раз когда пользователь запускает приложение
    func saveBlank(_ categoryList: [CategoryList]) {
        write {
            realm.add(categoryList)
        }
    }
    //MARK: - Метод сохраняет новый список
    
    func saveCategory(_ categoryList: CategoryList) {
        write {
            realm.add(categoryList)
        }
    }
    //MARK: - Удаление список
    func delete(_ categoryList: CategoryList) {
        write {
            realm.delete(categoryList.tasks)
            realm.delete(categoryList)
        }
    }
    func rename(_ categoryList: CategoryList, to name: String) {
        write {
            categoryList.name = name
        }
    }
    
    //MARK: - Редактированние списков
    func edit(_ categoryList: CategoryList, newValue: String) {
        write {
            categoryList.name = newValue
        }
    }
    
    func done(_ categoryList: CategoryList) {
        write {
            categoryList.tasks.setValue(true, forKey: "isComplete")
        }
    }

    
    //MARK: - Tasks
    
    func saveTask(_ task: Task, to categoryList: CategoryList) {
        write {
            categoryList.tasks.append(task)
        }
    }
    
    func rename(_ task: Task, to name: String, withNote note: String) {
        write {
            task.name = name
            task.note = note
        }
    }
    
    func delete(_ tasks: Task) {
        write {
            realm.delete(tasks)
        }
    }
    
    func edit(_ taks: Task, newValue: String) {
        write {
            taks.name = newValue
        }
    }
    
    func done(_ tasks: Task) {
        write {
            tasks.isComplete.toggle()
        }
        
    }

    
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch let error {
            print(error)
        }
    }
}



