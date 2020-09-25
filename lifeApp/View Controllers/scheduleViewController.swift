//
//  SecondViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 11/4/19.
//  Copyright © 2019 Charles Oxendine. All rights reserved.
//

import UIKit

class scheduleViewController: UIViewController {

    // MARK: Properties
    var userUID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var parent = self.parent as! tabViewController
        var uid = parent.data()
        self.userUID = uid
        
        formatView()
    }

    func formatView() {
        
    }
    
    
}

