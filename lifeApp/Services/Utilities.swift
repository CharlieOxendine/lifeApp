//
//  Utilities.swift
//  lifeApp
//
//  Created by Charles Oxendine on 11/10/19.
//  Copyright © 2019 Charles Oxendine. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width - 30 , height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    /// Returns current date as a formatted string
    static func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    static func errMessage(message: String, view: UIViewController) {
        let controller = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "Close", style: .default) { (true) in
            print("Error Message Closed")
        }
        
        controller.addAction(close)
        view.present(controller, animated: true)
    }

    static func okMessage(title: String, message: String, view: UIViewController) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "Ok", style: .default) { (true) in
            print("Ok message closed")
        }
        
        controller.addAction(close)
        view.present(controller, animated: true)
    }
    
    static func subscribeAlert(view: UIViewController) {
        let controller = UIAlertController(title: "Pro Feature", message: "You must be a pro user to access this feature. Would you like to subscribe?", preferredStyle: .alert)
        let close = UIAlertAction(title: "No", style: .default) { (true) in }
        let subscribe = UIAlertAction(title: "Yes", style: .default) { (true) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(identifier: "purchases") as? upgradePlanViewController
            view.present(newVC!, animated: true)
        }
        
        controller.addAction(close)
        controller.addAction(subscribe)
        view.present(controller, animated: true)
    }
    
    
    static func kelvinToFahrenheit(kelvin: Double) -> Double {
        let F = (( kelvin - 273.15) * 9/5) + 32
        return F
    }
    
    static func kelvinToCelsius(kelvin: Double) -> Double {
        let C = kelvin - 273.15
        return C
    }
    
}
