//
//  TaskListViewController.swift
//  TaskListApp
//
//  Created by Kate Kashko on 18.05.2023.
//

import UIKit

final class TaskListViewController: UITableViewController {
    
    private let viewContext = StorageManager.shared.persistentContainer.viewContext
    private let cellID = "cell"
    private var taskList: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID) // зарег-ли ячейку
        view.backgroundColor = .white
        setupNavigationBar()
        fetchData()
        
    }
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:
                            UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteTask = taskList[indexPath.row]
            StorageManager.shared.deleteContext(deleteTask)
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showAlert(withTitle: "Edit", andMessage: "", forRowAt: indexPath.row)
    }
    
    // MARK: - Alert
    @objc private func addNewTask() {
        showAlert(withTitle: "New Task", andMessage: "What do you want to do?", forRowAt: 0)
    }
    
    private func fetchData() {
        let fetchRequest = Task.fetchRequest()
        
        do {
            taskList = try viewContext.fetch(fetchRequest)
        } catch {
            print (error.localizedDescription)
        }
    }
    
    private func showAlert(withTitle title: String, andMessage message: String, forRowAt row: Int) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if message != "" {
            alert.addTextField { textText in
                textText.placeholder = "New Task"
            }
            let saveAction = UIAlertAction(title: "Save Task", style: .default) { [unowned self] _ in
                guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
                save(task)
            }
            alert.addAction(saveAction)
        } else {
            let editTask = taskList[row]
            alert.addTextField { textField in
                textField.text = editTask.title
            }
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
                guard let updatedTaskTitle = alert.textFields?.first?.text, !updatedTaskTitle.isEmpty else { return }
                
                editTask.title = updatedTaskTitle
                let cellIndex = IndexPath(row: row, section: 0)
                tableView.reloadRows(at: [cellIndex], with: .automatic)
                StorageManager.shared.saveContext()
            }
            alert.addAction(saveAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func save(_ taskName: String) {
        let task = Task(context: viewContext)
        task.title = taskName
        taskList.append(task)
        
        let indexPath = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        dismiss(animated: true)
    }
}


//MARK: - SetupUI
private extension TaskListViewController {
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(named: "MilkBlue")
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance //цвет для маленького заголовка
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance //для большого заголовка
        
        //Add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        navigationController?.navigationBar.tintColor = .white
    }
}



