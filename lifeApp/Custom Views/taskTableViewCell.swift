//
//  taskTableViewCell.swift
//  lifeApp
//
//  Created by Charles Oxendine on 11/4/19.
//  Copyright © 2019 Charles Oxendine. All rights reserved.
//

import UIKit

protocol taskTableViewCellDelegate {
    func reloadData()
}

class taskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var daysSinceLbl: UILabel!
    @IBOutlet weak var markCompleteIndicator: UIButton!
    
    var currentTask: task?
    var delegate: taskTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(task: task) {
        self.currentTask = task
        titleLabel.text = task.title
        
        if Calendar.current.isDateInToday(task.dueDate!.dateValue()) == true {
            self.daysSinceLbl.text = "Due Today"
        } else {
            if task.dueDate!.dateValue() < Date() {
                self.daysSinceLbl.textColor = .red
                self.daysSinceLbl.text = "Was due \(getDateSince(dateDue: task.dueDate?.dateValue() ?? Date()))"
            } else {
                self.daysSinceLbl.text = "Due \(getDateSince(dateDue: task.dueDate?.dateValue() ?? Date()))"
            }
        }
        
        if task.completed == true {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: task.title)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            self.titleLabel.attributedText = attributeString
            
            let filledImage = UIImage(systemName: "circle.fill")
            self.markCompleteIndicator.setImage(filledImage, for: .normal)
        
        }
        
        setTheme()
    }
    
    func setTheme() {
        switch _userServices.shared.currentUser.themeColor {
        case 0:
            self.markCompleteIndicator.tintColor = themeUIColor().darkGray
        case 1:
            self.markCompleteIndicator.tintColor = themeUIColor().pinkRed
        case 2:
            self.markCompleteIndicator.tintColor = themeUIColor().green
        case 3:
            self.markCompleteIndicator.tintColor = themeUIColor().blue
        case 4:
            self.markCompleteIndicator.tintColor = themeUIColor().banana
        case 5:
            self.markCompleteIndicator.tintColor = themeUIColor().darkTeal
        default:
            self.markCompleteIndicator.tintColor = themeUIColor().darkGray
        }
    }
    
    func getDateSince(dateDue: Date) -> String {
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let string = formatter.localizedString(for: dateDue, relativeTo: Date())
        return string
        
    }
    
    @IBAction func completeTapped(_ sender: Any) {
        
        guard self.currentTask != nil else { return }
        firestoreTaskServices.shared.markTaskDone(taskID: self.currentTask!.id) { (err) in
            if err != nil {
                return
            }
            
            self.delegate?.reloadData()
        }
        
    }
    
}
