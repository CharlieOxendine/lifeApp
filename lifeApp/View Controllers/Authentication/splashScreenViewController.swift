//
//  splashScreenViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 11/4/19.
//  Copyright © 2019 Charles Oxendine. All rights reserved.
//

import UIKit
import FirebaseAuth
import Purchases

class splashScreenViewController: UIViewController {

    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuth()
        setUI()
    }
    
    func setUI() {
        self.createAccountButton.layer.cornerRadius = 15
        self.loginButton.layer.cornerRadius = 15
    }
    
    func checkAuth() {
        if Auth.auth().currentUser != nil {
            Purchases.debugLogsEnabled = true
            Purchases.configure(withAPIKey: Constants.shared.revenueCatKey, appUserID: Auth.auth().currentUser!.uid)
            
            _userServices.shared.setUser(vc: nil, uid: Auth.auth().currentUser!.uid) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newVC = storyboard.instantiateViewController(identifier: "tabBarControl") as? tabViewController
                newVC?.selectedIndex = 1
                self.present(newVC!, animated: true)
            }
        }
    }
}
