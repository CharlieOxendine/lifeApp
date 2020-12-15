//
//  notifsOnboardingViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 12/14/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import UIKit

class notifsOnboardingViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var notifTimePicker: UIDatePicker!
    
    var uid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    func setUI() {
        self.submitButton.layer.cornerRadius = 15
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        let pickerDate = self.notifTimePicker.date
        
        let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "HH:mm"
        let newDateString = dateFormatter.string(from: pickerDate)
        let timeToNotifyStr = "\(newDateString)"
        
        firestoreServices.shared.updateNotifTime(timeToNotify: timeToNotifyStr) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(identifier: "tabBarControl") as? tabViewController
            newVC?.selectedIndex = 1
            newVC?.userUID = self.uid
            self.present(newVC!, animated: true)
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
