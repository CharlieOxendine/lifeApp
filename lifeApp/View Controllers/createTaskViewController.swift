//
//  createTaskViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 11/4/19.
//  Copyright © 2019 Charles Oxendine. All rights reserved.
//

import UIKit
import FirebaseFirestore

class createTaskViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var dueTodaySwitch: UISwitch!
    @IBOutlet weak var errorLabel: UILabel!
    
    var taskCreated: task = task(uid: "", date: Date(), title: "", notes: "", dueDate: Date()) //Dummy Value
    var currentUser = "AO32NOINOisn12"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func formatView() {
        errorLabel.alpha = 0
    }
    
    @IBAction func dueDateValueSwitched(_ sender: Any) {
        if dueTodaySwitch.isOn == false {
            UIView.animate(withDuration: 0.5) {
                self.datePicker.center.x += 1000
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.datePicker.center.x -= 1000
            }
        }
    }
    
    @IBAction func addTaskButtonTouched(_ sender: Any) {
        if titleField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            errorLabel.text = "Please fill in a title"
            errorLabel.alpha = 1
        } else {
            //Store Data
            var dueDate = datePicker.date
            var title = titleField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            var notes = notesField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            var currentDate = Date()
            self.taskCreated = task(uid: currentUser, date: currentDate, title: title, notes: notes ?? "", dueDate: dueDate)
            //Segue back to To Do View controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(identifier: "toDo")
            self.dismiss(animated: true) {
                self.parent
                print("Added Task")
            }
        }
    }
}
