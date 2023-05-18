//
//  TaskViewController.swift
//  TaskListApp
//
//  Created by Kate Kashko on 18.05.2023.
//

import UIKit

final class NewTaskViewController: UIViewController {
    private lazy var taskTextfield: UITextField = { //lazy откладывает инициализацию
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "New task"
        textField.translatesAutoresizingMaskIntoConstraints = false // что бы поставить кастомные констрейнты
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        //Set attributes for button title
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 18)
        
        //Create button
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = UIColor(named: "MilkBlue")
        buttonConfiguration.buttonSize = .medium // это значение по умолчанию, его можно и не указывать
        buttonConfiguration.attributedTitle = AttributedString("Save Task", attributes: attributes)
        let button = UIButton(configuration: buttonConfiguration, primaryAction: UIAction { [unowned self] _ in
            save()
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        //Set attributes for button title
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 18)
        
        //Create button
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = UIColor(named: "MilkOrange")
        buttonConfiguration.buttonSize = .medium
        buttonConfiguration.attributedTitle = AttributedString("Cancel", attributes: attributes)
        let button = UIButton(configuration: buttonConfiguration, primaryAction: UIAction { [unowned self] _ in
            dismiss(animated: true)
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews(taskTextfield, saveButton, cancelButton)// в этот момент произойтет инициализация текстового поля
        setConstraints()
        
    }
    private func setupSubviews (_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            taskTextfield.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: taskTextfield.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    private func save() {
        dismiss(animated: true)
    }
}
