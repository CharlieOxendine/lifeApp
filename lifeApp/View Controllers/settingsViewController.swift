//
//  settingsViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 9/29/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController {

    @IBOutlet weak var color1Button: UIButton!
    @IBOutlet weak var color2Button: UIButton!
    @IBOutlet weak var color3Button: UIButton!
    @IBOutlet weak var color4Button: UIButton!
    @IBOutlet weak var color5Button: UIButton!
    @IBOutlet weak var color6Button: UIButton!
    
    var color1 = UIColor.darkGray
    var color2 = UIColor(red: 255, green: 68, blue: 112, alpha: 1)
    var color3 = UIColor.systemGreen
    var color4 = UIColor.systemTeal
    var color5 = UIColor(red: 255, green: 214, blue: 124, alpha: 1)
    var color6 = UIColor(red: 0, green: 159, blue: 158, alpha: 1)
    
    var delegate: settingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }

    func setUI() {
        self.color1Button.layer.cornerRadius = 15
        self.color2Button.layer.cornerRadius = 15
        self.color3Button.layer.cornerRadius = 15
        self.color4Button.layer.cornerRadius = 15
        self.color5Button.layer.cornerRadius = 15
        self.color6Button.layer.cornerRadius = 15
    }
    
    @IBAction func color1Tapped(_ sender: Any) {
        firestoreTaskServices.shared.updateTheme(vc: self, newColorCode: 0) {
            _userServices.shared.currentUser.themeColor = 0
            self.delegate?.updatedThemeColor()
        }
    }
    
    @IBAction func color2Tapped(_ sender: Any) {
        firestoreTaskServices.shared.updateTheme(vc: self, newColorCode: 1) {
            _userServices.shared.currentUser.themeColor = 1
            self.delegate?.updatedThemeColor()
        }
    }
    
    @IBAction func color3Tapped(_ sender: Any) {
        firestoreTaskServices.shared.updateTheme(vc: self, newColorCode: 2) {
            _userServices.shared.currentUser.themeColor = 2
            self.delegate?.updatedThemeColor()
        }
    }
    
    @IBAction func color4Tapped(_ sender: Any) {
        firestoreTaskServices.shared.updateTheme(vc: self, newColorCode: 3) {
            _userServices.shared.currentUser.themeColor = 3
            self.delegate?.updatedThemeColor()
        }
    }
    
    @IBAction func color5Tapped(_ sender: Any) {
        firestoreTaskServices.shared.updateTheme(vc: self, newColorCode: 4) {
            _userServices.shared.currentUser.themeColor = 4
            self.delegate?.updatedThemeColor()
        }
    }
    
    @IBAction func color6Tapped(_ sender: Any) {
        firestoreTaskServices.shared.updateTheme(vc: self, newColorCode: 5) {
            _userServices.shared.currentUser.themeColor = 5
            self.delegate?.updatedThemeColor()
        }
    }
    
}

enum themeColor: Int {
    case darkGray = 0, pinkRed, green, blue, banana, darkTeal
}

class themeUIColor {
    
    public var darkGray = UIColor.darkGray
    public var pinkRed = UIColor(red: 255/255, green: 68/255, blue: 112/255, alpha: 1)
    public var green = UIColor.systemGreen
    public var blue = UIColor.systemTeal
    public var banana = UIColor(red: 255/255, green: 214/255, blue: 124/255, alpha: 1)
    public var darkTeal = UIColor(red: 0/255, green: 159/255, blue: 158/255, alpha: 1)

}

protocol settingsViewControllerDelegate: AnyObject {
    func updatedThemeColor()
}
