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
    @IBOutlet weak var errorLabel: UILabel!
    
    var currentUserUID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()
    }
    
    func formatView() {
        
    }

    @IBAction func submitButtonPressed(_ sender: Any) {
        
        //Segue to next View Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "tabBarControl")
        newVC.modalPresentationStyle = .fullScreen
        self.present(newVC, animated: true)
    }
    
    func validateFields() -> String? {
        var email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if email == "" || password == "" {
            return "Please fill in all fields."
        } else {
            return nil
        }
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        let validate = validateFields()
        print(validate)
        if validate == nil {
            //Authenticate
            let auth = Auth.auth()
            var email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            var password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let signIn = auth.signIn(withEmail: email!, password: password!) { (authData, err) in
                if err != nil {
                    print("Error: \(err!)")
                    self.errorLabel.text = err! as! String
                } else {
                    print("Signed In")
                    self.currentUserUID = (authData?.user.uid)!
                }
            }
            //Segue
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(withIdentifier: "tabBarControl") as! tabViewController
            newVC.userUID = ""
            newVC.modalPresentationStyle = .fullScreen
            self.present(newVC, animated: true)
        } else {
            errorLabel.text = validate
            errorLabel.alpha = 1
        }
    }
    
}
