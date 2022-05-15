//
//  WhatToDoList.swift
//  WhatToDoRealm
//
//  Created by Temur Juraev on 12.05.2022.
//

import RealmSwift

class CategoryList: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    @objc dynamic var color: String = ""
    
    let tasks = List<Task>()
}


class Task: Object {
    @objc dynamic  var name = ""
    @objc dynamic  var note = ""
    @objc dynamic  var date = Date()
    @objc dynamic  var isComplete = false
}
