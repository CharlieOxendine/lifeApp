//
//  FirstViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 11/4/19.
//  Copyright © 2019 Charles Oxendine. All rights reserved.
//

import UIKit

class mindViewController: UIViewController {

    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var greeting: UILabel! /* "Hello USER_NAME!" must have the whole greeting as it's value */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func formatView() {
        print("formatted view...")
    }
}

