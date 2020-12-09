//
//  eventTableViewCell.swift
//  lifeApp
//
//  Created by Charles Oxendine on 9/29/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import UIKit

class eventTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeRangeLbl: UILabel!
    @IBOutlet weak var calenderIndicator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setCell(event: Event) {
        self.titleLbl.text = event.eventTitle
        
        setTheme()
        
        if event.isAllDay == false {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            self.timeRangeLbl.text = "\(timeFormatter.string(from: event.startTime)) - \(timeFormatter.string(from: event.endTime))"
        } else {
            self.timeRangeLbl.text = "All Day"
        }
    
    }
    
    func setTheme() {
        switch _userServices.shared.currentUser.themeColor {
        case 0:
            self.calenderIndicator.tintColor = themeUIColor().darkGray
        case 1:
            self.calenderIndicator.tintColor = themeUIColor().pinkRed
        case 2:
            self.calenderIndicator.tintColor = themeUIColor().green
        case 3:
            self.calenderIndicator.tintColor = themeUIColor().blue
        case 4:
            self.calenderIndicator.tintColor = themeUIColor().banana
        case 5:
            self.calenderIndicator.tintColor = themeUIColor().darkTeal
        default:
            self.calenderIndicator.tintColor = themeUIColor().darkGray
        }
    }
}
