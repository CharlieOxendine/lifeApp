//
//  dateCollectionViewCell.swift
//  lifeApp
//
//  Created by Charles Oxendine on 9/27/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import UIKit

class dateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var dayOfMonthLBL: UILabel!
    
    var currentDate: Date?
    
    func setCell(day: Int) {
        self.dayOfMonthLBL.text = String(day)
        self.mainContentView.layer.cornerRadius = self.mainContentView.frame.height/2
    }
    
}
