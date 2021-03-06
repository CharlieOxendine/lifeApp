//
//  userServices.swift
//  lifeApp
//
//  Created by Charles Oxendine on 1/3/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class _userServices {
    
    static var shared = _userServices()
    var currentUser = user()
    
    var notifsEnabled: Bool?
    var notifsTime: String?
    
    var darkmodeEnabled: Bool?
    
    func setUser(vc: UIViewController?, uid: String, completion: @escaping () -> ()) {
        currentUser.setUser(vc: vc ?? UIViewController(), userUID: uid) { (success) in
            if success == true {
                completion()
            } else {
                Utilities.errMessage(message: "Error getting user data. Please try again or contact customer support.", view: vc ?? UIViewController())
            }
        }
    }
    
    /// Removes user object from memory and returns bool indicating success
    func logOutUser() {
        self.currentUser = user()
        self.notifsEnabled = false
        try? Auth.auth().signOut()
    }
    
}
