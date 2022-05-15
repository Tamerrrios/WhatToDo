//
//  DataManager.swift
//  WhatToDoRealm
//
//  Created by Temur Juraev on 12.05.2022.
//

import RealmSwift

class DataManager {
    static let shared = DataManager()

    private init() {}

    func createTempData(_ completion: @escaping() -> Void) {
       if !UserDefaults.standard.bool(forKey: "done") {
        UserDefaults.standard.set(true, forKey: "done")
            
            let shoppingList = CategoryList()
            shoppingList.name = "Shopping List"
            
            let movieList = CategoryList()
            movieList.name = "Movie List"
           
           let educationList = CategoryList()
           educationList.name = "Education"
           
           let swift = Task(value: ["Learn SwiftUI", "Finish first project", Date(), true])
            
            let interstellar = Task(value: ["Interstellar", "must to watch", Date(), true])
            
            let milk = Task()
            milk.name = "Milk"
            milk.note = "2L"
            
            let bread = Task(value: ["Bread", "", Date(), true])
            let apples = Task(value: ["name": "apples", "note": "2kg"])
            
            shoppingList.tasks.append(milk)
            shoppingList.tasks.insert(contentsOf: [bread, apples], at: 1)
            movieList.tasks.append(interstellar)
           educationList.tasks.append(swift)
            
            DispatchQueue.main.async {
                StorageManager.shared.saveBlank([shoppingList, movieList, educationList])
                completion()
            }
            
            
        }
            

    }

}
