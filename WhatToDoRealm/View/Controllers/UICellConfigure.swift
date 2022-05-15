//
//  UICellConfigure.swift
//  WhatToDoRealm
//
//  Created by Temur Juraev on 14.05.2022.
//

import UIKit

extension UITableViewCell {
    
    func cellSettings(with categoryList: CategoryList) {
        let currentTask = categoryList.tasks.filter("isComplete = false")
        var content = defaultContentConfiguration()
        content.textProperties.color = .white
        content.secondaryTextProperties.color = .white
        content.textProperties.font = UIFont.systemFont(ofSize: 25.0)
        content.text = categoryList.name
    
        
        if categoryList.tasks.isEmpty {
            content.secondaryText = "0"
            accessoryType = .none
        } else if currentTask.isEmpty {
            content.secondaryText = nil
            accessoryType = .checkmark
        } else {
            content.secondaryText = "\(categoryList.tasks.count)"
            accessoryType = .none
        }

        
        contentConfiguration = content
        
    }
}

