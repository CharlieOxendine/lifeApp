//
//  newTaskViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 8/26/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import UIKit
import FirebaseFirestore

protocol newTaskViewControllerDelegate: AnyObject {
    func viewClosed()
}

class newTaskViewController: UIViewController {

    @IBOutlet weak var taskTitleField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var createTaskButton: UIButton!
    
    var delegate: newTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))

        setUI()
    }
    
    func setUI() {
        self.createTaskButton.layer.cornerRadius = 15
        
        self.dueDatePicker.datePickerMode = .date
        self.dueDatePicker.minimumDate = Date()
    }
    
    @IBAction func createTaskTapped(_ sender: Any) {
        guard self.taskTitleField.text != nil else {
            Utilities.errMessage(message: "Please give your task a title.", view: self)
            return
        }
        
        guard let newTitle = self.taskTitleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
    
        let newNote = (self.notesField.text?.trimmingCharacters(in: .whitespacesAndNewlines))
        let id = UUID().uuidString
        
        let newTask = task(date: Timestamp(date: Date()), title: newTitle, notes: newNote ?? "", dueDate: Timestamp(date: self.dueDatePicker.date), completed: false, id: id)
        
        firestoreServices.shared.addTaskToDB(newTask: newTask) { (err) in
            if err != nil {
                Utilities.errMessage(message: err!, view: self)
                return
            }
            
            self.delegate?.viewClosed()
            
            self.dismiss(animated: true) {
                return
            }
        }
    }
}

