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
    @IBOutlet weak var errorLabel: UILabel!
    
    var userUID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userUID)
    }
    
    func validateFields() -> String? {
        var name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var passwordVerify = passwordVerifyField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if name == "" || email == "" || password == "" || passwordVerify == "" {
            return "Please fill in all fields."
        } else if password != passwordVerify {
            return "Your passwords don't match."
        } else {
            return nil
        }
    }

    @IBAction func createAccountButtonTouched(_ sender: Any) {
        var password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let validate = validateFields()
        print(validate)
        if validate == nil {
            //authenticate
            var auth = Auth.auth()
            auth.createUser(withEmail: email!, password: password!) { (authData, err) in
                if err != nil {
                    print("Error: \(err)")
                } else {
                    self.userUID = (authData?.user.uid)!
                    let db = Firestore.firestore()
                    let ref = db.collection("users").document(self.userUID).setData(["email" : email!, "name" : name!])
                    
                    //segue
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let newVC = storyboard.instantiateViewController(withIdentifier: "tabBarControl")
                    newVC.modalPresentationStyle = .fullScreen
                    self.present(newVC, animated: true)
                }
            }
        } else {
            errorLabel.text = validate
            errorLabel.alpha = 1
        }
    }
}
