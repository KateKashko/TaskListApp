//
//  TaskListViewController.swift
//  TaskListApp
//
//  Created by Kate Kashko on 18.05.2023.
//

import UIKit

final class TaskListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
    }


}

//MARK: - SetupUI
private extension TaskListViewController {
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
