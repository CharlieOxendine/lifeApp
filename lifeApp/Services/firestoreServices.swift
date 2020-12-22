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

class firestoreServices {
    
    static let shared = firestoreServices()
    
    let db = Firestore.firestore()
    
    // MARK: EVENTS MANAGMENT
    //Returns string error desc if not successful
    func markTaskCompletionStatus(completed: Bool, taskID: String, completion: @escaping (String?) -> ()) {
        db.collection("users").document(_userServices.shared.currentUser.uid).collection("tasks").document(taskID).updateData(["completed" : completed
        ]) { (err) in
            if err != nil {
                completion(err!.localizedDescription)
                return
            }
            
            completion(nil)
        }
    }
    
    //Returns string error desc if not successful
    func deleteTask(taskID: String, completion: @escaping (String?) -> ()) {
        db.collection("users").document(_userServices.shared.currentUser.uid).collection("tasks").document(taskID).delete { (err) in
            if err != nil {
                completion(err!.localizedDescription)
                return
            }
            
            completion(nil)
        }
    }
    
    //Returns string error desc if not successful
    func addTaskToDB(newTask: task, completion: @escaping (String?) -> ()) {
        guard _userServices.shared.currentUser.uid != nil else { return }
        
        do {
            try db.collection("users").document(_userServices.shared.currentUser.uid).collection("tasks").document(newTask.id).setData(from: newTask)
            completion(nil)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
            completion(error.localizedDescription)
        }
        
    }
    
    // MARK: EVENTS MANAGMENT
    //notifies user of error desc in this function if not successful and completion nil
    func addEventToDB(newEvent: Event, completion: @escaping (String?) -> ()) {
        do {
            try db.collection("users").document(_userServices.shared.currentUser.uid).collection("events").document(newEvent.eventID).setData(from: newEvent)
            completion(nil)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
            completion(error.localizedDescription)
        }
    }
    
    func getEventsInMonth(vc: UIViewController, month: Int, year: Int, completion: @escaping ([Event]) -> ()) {
        var eventsLoaded: [Event] = []
        
        let dateString = "5/\(month + 1)/\(year)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let refDate = dateFormatter.date(from: dateString)
        
        guard refDate != nil else { return }
        
        db.collection("users").document(_userServices.shared.currentUser.uid).collection("events").whereField("startTime", isGreaterThan: refDate!.startOfMonth).whereField("startTime", isLessThan: refDate!.endOfMonth).getDocuments { (snap, err) in
            if err != nil {
                Utilities.errMessage(message: err!.localizedDescription, view: vc)
                return
            }
            
            guard snap != nil else { return }
            
            for doc in snap!.documents {
                let result = Result {
                    try doc.data(as: Event.self)
                }
                
                switch result {
                    case .success(let event):
                        if let event = event {
                            print("Event: \(event)")
                            eventsLoaded.append(event)
                        } else {
                            Utilities.errMessage(message: "Document does not exist", view: vc)
                        }
                    case .failure(let error):
                        Utilities.errMessage(message: "Error decoding city: \(error)", view: vc)
                }
            }
            
            _userServices.shared.currentUser.todayEvents = eventsLoaded.filter { Calendar.current.compare(Date(), to: $0.startTime, toGranularity: .day) == ComparisonResult.orderedSame}
            completion(eventsLoaded)
        }
    }
    
    func updateTheme(vc: UIViewController, newColorCode: Int, completion: @escaping () -> ()) {
        
        db.collection("users").document(_userServices.shared.currentUser.uid).updateData(["themeColor" : newColorCode]) { (err) in
            if err != nil {
                Utilities.errMessage(message: err!.localizedDescription, view: vc)
                return
            }
            
            completion()
        }
    }
    
    func updateNotifTime(timeToNotify: String, completion: @escaping () -> ()) {
        guard let UID = _userServices.shared.currentUser.uid else {
            return
        }

        db.collection("users").document(UID).updateData(["notifTime" : timeToNotify, "notifsEnabled": true]) { (err) in
            if err == nil {
                completion()
            } 
        }
    }
    
    func updateNotifsEnabled(enabled: Bool, completion: @escaping () -> ()) {
        guard let UID = _userServices.shared.currentUser.uid else {
            return
        }

        db.collection("users").document(UID).updateData(["notifsEnabled": enabled]) { (err) in
            if err == nil {
                completion()
            }
        }
    }
    
    func deleteEvent(eventID: String, completion: @escaping (String?) -> ()) {
        db.collection("users").document(_userServices.shared.currentUser.uid).collection("events").document(eventID).delete { (err) in
            if err != nil {
                completion(err!.localizedDescription)
                return
            }
            
            completion(nil)
        }
    }
}
