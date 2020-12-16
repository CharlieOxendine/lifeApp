//
//  newTaskViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 8/24/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import UIKit
import FirebaseFirestore

protocol taskDetailViewControllerDelegate: AnyObject {
    func didCloseView()
}

class taskDetailViewController: UIViewController {

    @IBOutlet weak var taskTitleLbl: UILabel!
    @IBOutlet weak var timeSinceAddedLbl: UILabel!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    var currentTask: task!
    var delegate: taskDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notesField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        
        setTaskData()
        setUI()
    }

    func setUI() {
        self.deleteButton.layer.cornerRadius = 15
        
        self.notesField.layer.cornerRadius = 15
        self.notesField.layer.borderWidth = 1
        self.notesField.layer.borderColor = UIColor.darkGray.cgColor
        
        self.contentView.layer.cornerRadius = 25
        self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setTaskData() {
        self.taskTitleLbl.text = currentTask.title
        self.timeSinceAddedLbl.text = "\(currentTask.dueDate.dateValue().timeAgo()) ago"
        if currentTask.notes != "" {
            self.notesField.text = currentTask.notes
        }
    }
    
    func updateTaskNote(newField: String) {
        let newNote = newField
        
        let db = Firestore.firestore()
        
        db.collection("users").document(_userServices.shared.currentUser.uid).collection("tasks").document(currentTask.id).updateData(["notes" : newNote]) { (err) in
            if err != nil {
                Utilities.errMessage(message: err!.localizedDescription, view: self)
                return
            }
            
            print("Updated")
        }
    }
    
    @IBAction func deleteTaskTapped(_ sender: Any) {
        firestoreServices.shared.deleteTask(taskID: self.currentTask.id) { (err) in
            if err == nil {
                self.delegate?.didCloseView()
                self.dismiss(animated: true, completion: nil)
            } else {
                Utilities.okMessage(title: "Error", message: err!, view: self)
                return
            }
        }
    }
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension taskDetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.notesField.text == "Notes..." {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.notesField.text == "" {
            textView.text = "Notes..."
        }
        
        updateTaskNote(newField: notesField.text)
        self.delegate?.didCloseView()
    }
}
