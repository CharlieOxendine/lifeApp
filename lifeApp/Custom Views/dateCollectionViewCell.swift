//
//  dateCollectionViewCell.swift
//  lifeApp
//
//  Created by Charles Oxendine on 9/27/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import UIKit

class dateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayOfMonthLBL: UILabel!
    
    var currentDate: Date?
    
    func setCell(day: Int) {
        self.dayOfMonthLBL.text = String(day)
        setTheme()
    }
    
    func setTheme() {
        switch _userServices.shared.currentUser.themeColor {
        case 0:
            self.contentView.backgroundColor = themeUIColor().darkGray
        case 1:
            self.contentView.backgroundColor = themeUIColor().pinkRed
        case 2:
            self.contentView.backgroundColor = themeUIColor().green
        case 3:
            self.contentView.backgroundColor = themeUIColor().blue
        case 4:
            self.contentView.backgroundColor = themeUIColor().banana
        case 5:
            self.contentView.backgroundColor = themeUIColor().darkTeal
        default:
            self.contentView.backgroundColor = themeUIColor().darkGray
        }
    }
}
