//
//  loginViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 11/4/19.
//  Copyright © 2019 Charles Oxendine. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class loginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var currentUserUID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()
    }
    
    func formatView() {
        Utilities.styleTextField(emailField)
        Utilities.styleTextField(passwordField)
        
        self.submitButton.layer.cornerRadius = 15
    }
    
    func validateFields() -> String? {
        let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if email == "" || password == "" {
            return "Please fill in all fields."
        } else {
            return nil
        }
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        let validate = validateFields()

        if validate == nil {
            //Authenticate
            let auth = Auth.auth()
            let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            auth.signIn(withEmail: email!, password: password!) { (authData, err) in
                if err != nil {
                    print("Error loggin in user: \(err!)")
                    Utilities.errMessage(message: err!.localizedDescription, view: self)
                } else {
                
                    self.currentUserUID = (authData?.user.uid)!
                    let userUID = self.currentUserUID
                    _userServices.shared.setUser(vc: self, uid: userUID) {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let newVC = storyboard.instantiateViewController(identifier: "tabBarControl") as! tabViewController
                        newVC.userUID = self.currentUserUID
                        self.present(newVC, animated: true)
                    }
                }
            }
        } else {
            Utilities.errMessage(message: validate!, view: self)
        }
    }
}
