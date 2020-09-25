//
//  userServices.swift
//  lifeApp
//
//  Created by Charles Oxendine on 1/3/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import Foundation
import UIKit

class _userServices {
    
    static var shared = _userServices()
    var currentUser = user()
    
    func setUser(vc: UIViewController, uid: String, completion: @escaping () -> ()) {
        currentUser.setUser(vc: vc, userUID: uid) { (success) in
            if success == true {
                completion()
            } else {
                Utilities.errMessage(message: "Error getting user data. Please try again or contact customer support.", view: vc)
            }
        }
    }
    
    /// Removes user object from memory and returns bool indicating success
    func logOutUser() -> Bool {
        self.currentUser = user()
        return true
    }
    
}
