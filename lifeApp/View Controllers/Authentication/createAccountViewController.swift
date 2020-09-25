//
//  createAccountViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 11/4/19.
//  Copyright © 2019 Charles Oxendine. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class createAccountViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordVerifyField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()
    }
    
    func formatView() {
        Utilities.styleTextField(nameField)
        Utilities.styleTextField(emailField)
        Utilities.styleTextField(passwordField)
        Utilities.styleTextField(passwordVerifyField)
        
        self.submitButton.layer.cornerRadius = 15
    }
    
    func validateFields() -> String? {
        let name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordVerify = passwordVerifyField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if name == "" || email == "" || password == "" || passwordVerify == "" {
            return "Please fill in all fields."
        } else if password != passwordVerify {
            return "Your passwords don't match."
        } else if Utilities.isPasswordValid(password!) != true {
            return "Make sure your password is at least 8 characters with a special character and a capitalized letter!"
        } else {
            return nil
        }
    }

    @IBAction func createAccountButtonTouched(_ sender: Any) {
        
        let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let validate = validateFields()

        if validate == nil {
            //authenticate
            let auth = Auth.auth()
            auth.createUser(withEmail: email!, password: password!) { (authData, err) in
                if err != nil {
                    Utilities.errMessage(message: err!.localizedDescription, view: self)
                    return
                } else {
                    let uid = (authData?.user.uid)!
                    
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).setData(["email" : email!, "name" : name!])
                    
                    _userServices.shared.setUser(vc: self, uid: uid) {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let newVC = storyboard.instantiateViewController(identifier: "tabBarControl") as! tabViewController
                        newVC.userUID = authData!.user.uid
                        self.present(newVC, animated: true)
                    }
                }
            }
        } else {
            Utilities.errMessage(message: validate!, view: self)
        }
    }
}
