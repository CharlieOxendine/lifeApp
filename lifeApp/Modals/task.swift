//
//  task.swift
//  lifeApp
//
//  Created by Charles Oxendine on 11/4/19.
//  Copyright © 2019 Charles Oxendine. All rights reserved.
//

import Foundation

class task {
    var userUID = ""
    var dateCreated: Date = Date()
    var title = ""
    var notes = ""
    var dueDate: Date = Date()
    
    init(uid: String, date: Date, title: String, notes: String, dueDate: Date) {
        self.userUID = uid
        self.dateCreated = date
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
    }
}
