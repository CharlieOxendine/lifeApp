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
    
    var taskCreated: task?
    var userUID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 0.5) {
            self.datePicker.center.x += 1000
        }
    }
    
    func formatView() {
        errorLabel.alpha = 0
    }
    
    // MARK: - Due Date Today Switch
    @IBAction func dueDateValueSwitched(_ sender: Any) {
        if dueTodaySwitch.isOn == true {
            UIView.animate(withDuration: 0.5) {
                self.datePicker.center.x -= 1000
                self.datePicker.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.datePicker.center.x += 1000
                self.datePicker.alpha = 1
            }
        }
    }
    
    // MARK: Add Task Button Touched
    @IBAction func addTaskButtonTouched(_ sender: Any) {
        if titleField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            errorLabel.text = "Please fill in a title"
            errorLabel.alpha = 1
        } else {
            
            
            //Each Data Point for task
            var dueDate = self.datePicker.date
            let title = titleField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let notes = notesField.text!
            let currentDate = Date()
            var today = false
            if currentDate == dueDate {
                today = true
            }
            //Add Task to Cloud Storage
            let db = Firestore.firestore()
            let DBtasksCollection = db.collection("users").document(userUID).collection("tasks")
            let formattedDueDate = dueDate
            let formattedCurrentDate = Timestamp(date: currentDate)
            var new: DocumentReference? = nil
            
            var data = ["title" : title, "notes": notes, "dateCreated" : formattedCurrentDate, "dueDate": dueDate, "uid" : userUID, "completed" : false, "active" : true, "ID": ""] as [String : Any]
        
            new = DBtasksCollection.addDocument(data: data) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(new!.documentID)")
                        var ID = db.collection("posts").document(new!.documentID)
                        new!.updateData(["ID" : new!.documentID])
                }
            }
            
            //add to task created
            taskCreated = task(date: formattedCurrentDate, title: title, notes: notes ?? "", dueDate: Timestamp(date: formattedDueDate), completed: false, id: "")
        }
    }
}
