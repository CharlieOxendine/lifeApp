//
//  task.swift
//  lifeApp
//
//  Created by Charles Oxendine on 11/4/19.
//  Copyright © 2019 Charles Oxendine. All rights reserved.
//

import Foundation
import FirebaseFirestore

class task: Codable {
    var dateCreated: Timestamp!
    var title: String!
    var notes: String?
    var dueDate: Timestamp!
    var completed: Bool!
    var id: String!
    
    init(date: Timestamp, title: String, notes: String, dueDate: Timestamp, completed: Bool, id: String) {
        self.dateCreated = date
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.completed = completed
        self.id = id
    }
    
    enum CodingKeys: String, CodingKey {
        case dateCreated
        case title
        case notes
        case dueDate
        case completed
        case id
    }
}
