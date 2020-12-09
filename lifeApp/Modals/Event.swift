//
//  Event.swift
//  lifeApp
//
//  Created by Charles Oxendine on 9/29/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import Foundation

struct Event: Codable {
    
    var eventTitle: String!
    var eventDesc: String?
    var startTime: Date!
    var endTime: Date!
    var isAllDay: Bool!
    var eventID: String!
    
    enum CodingKeys: String, CodingKey {
        case eventTitle
        case eventDesc
        case startTime
        case endTime
        case isAllDay
        case eventID
    }
    
}
