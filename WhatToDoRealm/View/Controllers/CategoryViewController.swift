//
//  CategoryViewController.swift
//  WhatToDoRealm
//
//  Created by Temur Juraev on 12.05.2022.
//

import RealmSwift
import ChameleonFramework

class CategoryViewController: UITableViewController {
    
    private var categoryLists: Results<CategoryList>!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        createTempData()
        setupbar()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        let addButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
            )
    
        
        navigationItem.rightBarButtonItem = addButtonItem
        addButtonItem.tintColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.leftBarButtonItem = editButtonItem
        categoryLists = StorageManager.shared.realm.objects(CategoryList.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        let categoryList = categoryLists[indexPath.row]
        cell.cellSettings(with: categoryList)
        cell.backgroundColor = RandomFlatColor()

            
    
        return cell
        
        }
        

    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let categoryList = categoryLists[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(categoryList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, IsDone in
            self.showAlert(with: categoryList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            IsDone(true)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _, isDone in
            StorageManager.shared.done(categoryList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            isDone(true)
        }
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        guard let taskVC = segue.destination as? TasksViewController else {return}
        let categoryList = categoryLists[indexPath.row]
        taskVC.categoryList = categoryList
    }
    
    @objc func addButtonPressed() {
        showAlert()
    }
    private func createTempData() {
        DataManager.shared.createTempData {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func sortedSegmented(_ sender: UISegmentedControl) {
        categoryLists = sender.selectedSegmentIndex == 0
        ? categoryLists.sorted(byKeyPath: "date")
        : categoryLists.sorted(byKeyPath: "name")
        tableView.reloadData()
    }
    
}

extension CategoryViewController {
    private func showAlert(with categoryList: CategoryList? = nil, completion: (() -> Void)? = nil) {
        let title = categoryList != nil ? "Edit List" : "New Category"
        
        let alert = AlertController.createAlert(withTitle: title, andMessage: "Please insert new value")
        alert.action(with: categoryList) { newValue in
            if let categoryList = categoryList, let completion = completion {
                StorageManager.shared.edit(categoryList, newValue: newValue)
                completion()
            } else {
                self.save(newValue)
            }
            self.tableView.reloadData()
           
        }
        present(alert, animated: true)
    }
    
    private func save(_ categoryList: String) {
        let categoryList = CategoryList(value: [categoryList])
        StorageManager.shared.saveCategory(categoryList)
        let rowIndex = IndexPath(row: categoryLists.firstIndex(of: categoryList) ?? 0, section: 0)
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
    
    private func setupbar() {
        navigationItem.title = "WhatToDo"
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor.systemBlue
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}




