//
//  newEventViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 9/27/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import UIKit

protocol newEventViewControllerDelegate: AnyObject {
    func didAddEvent()
}

class newEventViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var confirmDateButton: UIButton!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var eventTitleField: UITextField!
    @IBOutlet weak var eventDateField: UITextField!
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var instructLBL: UILabel!
    @IBOutlet weak var allDaySwitch: UISwitch!
    
    var delegate: newEventViewControllerDelegate?
    
    var startTime: Date?
    var endTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventDateField.delegate = self
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))

        setUI()
    }

    func setUI() {
        Utilities.styleTextField(descField)
        Utilities.styleTextField(eventTitleField)
        Utilities.styleTextField(eventDateField)
        
        self.datePicker.minimumDate = Date()
        
        self.confirmDateButton.layer.cornerRadius = 15
        self.createEventButton.layer.cornerRadius = 15
    }
    
    @IBAction func confirmDateTapped(_ sender: Any) {
        let dateFormatterFull = DateFormatter()
        let dateFormatterTime = DateFormatter()
        
        if self.allDaySwitch.isOn == true {
            dateFormatterFull.dateFormat = "MMM dd,yyyy"
            dateFormatterTime.dateFormat = "MMM dd,yyyy"
        } else {
            dateFormatterFull.dateFormat = "MMM dd,yyyy h:mm a"
            dateFormatterTime.dateFormat = "h:mm a"
        }
        
        if startTime == nil {
            self.startTime = self.datePicker.date
            self.eventDateField.text = "\(dateFormatterFull.string(from: self.startTime!)) -"
            self.confirmDateButton.setTitle("Confirm End Date", for: .normal)
            
            if self.allDaySwitch.isOn == false {
                self.datePicker.datePickerMode = .time
            }
        } else {
            self.endTime = self.datePicker.date
            self.confirmDateButton.alpha = 0
            self.datePicker.alpha = 0
            
            let sameDay = Calendar.current.isDate(self.startTime!, equalTo: self.endTime!, toGranularity: .day)
            if sameDay == true {
                self.eventDateField.text = "\(dateFormatterFull.string(from: self.startTime!)) - \(dateFormatterTime.string(from: self.endTime!))"
            } else {
                self.eventDateField.text = "\(dateFormatterFull.string(from: self.startTime!)) - \(dateFormatterFull.string(from: self.endTime!))"
            }
        
            self.eventDateField.alpha = 1
        }
    }
    
    @IBAction func createEvent(_ sender: Any) {
        guard self.eventTitleField.text != nil && self.eventTitleField.text != "" else {
            Utilities.errMessage(message: "Please fill in a title for your event.", view: self)
            return
        }
        
        guard self.startTime != nil && self.endTime != nil else {
            if self.startTime == nil {
                Utilities.errMessage(message: "Please pick a start and end time for your event", view: self)
                return
            } else {
                Utilities.errMessage(message: "Please pick an end time for your event", view: self)
                return
            }
        }
        
        var desc = self.descField.text
        if desc != "" { desc = nil }
        
        let event = Event(eventTitle: self.eventTitleField.text, eventDesc: desc, startTime: self.startTime, endTime: self.endTime, isAllDay: self.allDaySwitch.isOn, eventID: UUID().uuidString)
        firestoreServices.shared.addEventToDB(newEvent: event) { (err) in
            if err != nil {
                Utilities.errMessage(message: err!, view: self)
                return
            }
            
            self.delegate?.didAddEvent()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func allDayToggle(_ sender: Any) {
        if allDaySwitch.isOn == true {
            self.datePicker.datePickerMode = .date
            self.startTime = nil
            self.endTime = nil
            self.eventDateField.text = ""
        } else {
            self.datePicker.datePickerMode = .dateAndTime
            self.startTime = nil
            self.endTime = nil
            self.eventDateField.text = ""
        }
    }
}

extension newEventViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.endEditing(true)
        self.startTime = nil
        self.endTime = nil
        
        if self.allDaySwitch.isOn == false {
            self.datePicker.datePickerMode = .dateAndTime
        }
        
        self.confirmDateButton.setTitle("Confirm Start Date", for: .normal)
        self.datePicker.alpha = 1
        self.confirmDateButton.alpha = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.datePicker.alpha = 1
        self.confirmDateButton.alpha = 1
    }
    
}
