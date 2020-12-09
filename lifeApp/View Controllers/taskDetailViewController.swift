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
    
    var currentTaskID: String?
    var delegate: taskDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notesField.delegate = self
        
        getTask()
        setUI()
    }

    func setUI() {
        self.deleteButton.layer.cornerRadius = 15
        
        self.notesField.layer.cornerRadius = 15
        self.notesField.layer.borderWidth = 1
        self.notesField.layer.borderColor = UIColor.darkGray.cgColor
        
    }
    
    func getTask() {
        let db = Firestore.firestore()
        
        db.collection("users").document(_userServices.shared.currentUser.uid).collection("tasks").document(self.currentTaskID!).getDocument { (snap, err) in
            if err != nil {
                Utilities.errMessage(message: err!.localizedDescription, view: self)
                return
            }
            
            let result = Result {
                try snap!.data(as: task.self)
            }
            
            switch result {
                case .success(let task):
                    if let task = task {
                        self.taskTitleLbl.text = task.title
                        self.timeSinceAddedLbl.text = "\(task.dueDate.dateValue().timeAgo()) ago"
                        self.notesField.text = task.notes
                    } else {
                        print("Document does not exist")
                    }
                case .failure(let error):
                    print("Error decoding city: \(error)")
            }
        }
    }
    
    func updateTaskNote(newField: String) {
        let newNote = newField
        
        let db = Firestore.firestore()
        
        db.collection("users").document(_userServices.shared.currentUser.uid).collection("tasks").document(self.currentTaskID!).updateData(["notes" : newNote]) { (err) in
            if err != nil {
                Utilities.errMessage(message: err!.localizedDescription, view: self)
                return
            }
            
            print("Updated")
        }
    }
    
    @IBAction func deleteTaskTapped(_ sender: Any) {
        let db = Firestore.firestore()
        db.collection("users").document(_userServices.shared.currentUser.uid).collection("tasks").document(self.currentTaskID!).delete { (err) in
            if err != nil {
                Utilities.errMessage(message: err!.localizedDescription, view: self)
                return
            }
            
            self.delegate?.didCloseView()
            self.dismiss(animated: true, completion: nil)
        }
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
