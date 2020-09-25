//
//  firestoreServices.swift
//  lifeApp
//
//  Created by Charles Oxendine on 8/24/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class firestoreTaskServices {
    
    static let shared = firestoreTaskServices()
    
    //MARK: TASKS
    //Returns string error desc if not successful
    func markTaskDone(taskID: String, completion: @escaping (String?) -> ()) {
        let db = Firestore.firestore()
        db.collection("users").document(_userServices.shared.currentUser.uid).collection("tasks").document(taskID).updateData(["completed" : true]) { (err) in
            if err != nil {
                completion(err!.localizedDescription)
                return
            }
            
            completion(nil)
        }
    }
    
    //Returns string error desc if not successful
    func deleteTask(taskID: String, completion: @escaping (String?) -> ()) {
        let db = Firestore.firestore()
        db.collection("users").document(_userServices.shared.currentUser.uid).collection("tasks").document(taskID).delete { (err) in
            if err != nil {
                completion(err!.localizedDescription)
                return
            }
            
            completion(nil)
        }
    }
    
    func addTaskToDB(newTask: task, completion: @escaping (String?) -> ()) {
        let db = Firestore.firestore()
        
        guard _userServices.shared.currentUser.uid != nil else { return }
        
        do {
            try db.collection("users").document(_userServices.shared.currentUser.uid).collection("tasks").document(newTask.id).setData(from: newTask)
            completion(nil)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
            completion(error.localizedDescription)
        }
        
    }
}
