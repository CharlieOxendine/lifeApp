//
//  user.swift
//  lifeApp
//
//  Created by Charles Oxendine on 1/3/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class user {
    
    var uid: String!
    var tasks: [task] = []
    var todayEvents: [Event] = []
    var name: String?
    var themeColor: Int = 0
        
    func setUser(vc: UIViewController, userUID: String, completion: @escaping (Bool) -> ()) {
        self.uid = userUID
        
        let db = Firestore.firestore()
        db.collection("users").document(self.uid).getDocument { (snap, err) in
            if err != nil {
                Utilities.errMessage(message: err!.localizedDescription, view: vc)
                return
            }
            
            let userName = snap?.data()?["name"] as? String
            let theme = snap?.data()?["themeColor"] as? Int
            
            self.name = userName ?? nil
            self.themeColor = theme ?? self.themeColor
            completion(true)
        }
    }
    
    func getTasks(completion: @escaping (Bool?) -> ()) {
        let db = Firestore.firestore()
        db.collection("users").document(self.uid).collection("tasks").getDocuments { (snap, err) in
            if err != nil {
                print("Error: \(err!.localizedDescription)")
                return
            }
            
            var loadedTasks: [task] = []
            
            for docs in snap!.documents {
                let result = Result {
                    try docs.data(as: task.self)
                }
                
                switch result {
                    case .success(let task):
                        if let task = task {
                            loadedTasks.append(task)
                        } else {
                            print("Document does not exist")
                            completion(false)
                        }
                    case .failure(let error):
                        print("Error decoding city: \(error)")
                        completion(false)
                }
            }
            
            self.tasks = loadedTasks
            completion(true)
        }
    }
}
