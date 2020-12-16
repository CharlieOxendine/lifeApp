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
    @IBOutlet weak var monthCollection: UICollectionView!
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var currentMonthLbl: UILabel!
    @IBOutlet weak var eventsListTitleLbl: UILabel!
    
    var daysArray: [Int] = []
    var daysInMonth: [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 30, 31, 30]
    
    var currentMonthIndex: Int? //The current month index showing day in that month
    var currentDayIndex: Int?
    
    var monthEvents: [Event] = []
    var todaysEvents: [Event] = []
    
    var currentYear: Int?
    var settingTintColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTheme()
        
        self.monthCollection.delegate = self
        self.monthCollection.dataSource = self
        
        self.eventsTable.delegate = self
        self.eventsTable.dataSource = self
        
        setCurrentMonth()
    }

    override func viewDidAppear(_ animated: Bool) {
        setTheme()
        setCurrentMonth()
    }
    
    func setTheme() {
        switch _userServices.shared.currentUser.themeColor {
        case 0:
            self.settingTintColor = themeUIColor().darkGray
        case 1:
            self.settingTintColor = themeUIColor().pinkRed
        case 2:
            self.settingTintColor = themeUIColor().green
        case 3:
            self.settingTintColor = themeUIColor().blue
        case 4:
            self.settingTintColor = themeUIColor().banana
        case 5:
            self.settingTintColor = themeUIColor().darkTeal
        default:
            self.settingTintColor = themeUIColor().darkGray
        }
    }
    
    func setCurrentMonth() {
        let currentDate = Date()
        
        if self.currentDayIndex == nil {
            let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: currentDate)
            let month = calanderDate.month
            let year = calanderDate.year
            let day = calanderDate.day
            
            if month != nil { self.currentMonthIndex = month! - 1 }
            if year != nil { self.currentYear = year }
            if day != nil { self.currentDayIndex = day! + 1 }
        }
        
        setDays()
        
        switch currentMonthIndex {
            case 0:
                self.currentMonthLbl.text = "January"
            case 1:
                self.currentMonthLbl.text = "Febuary"
            case 2:
                self.currentMonthLbl.text = "March"
            case 3:
                self.currentMonthLbl.text = "April"
            case 4:
                self.currentMonthLbl.text = "May"
            case 5:
                self.currentMonthLbl.text = "June"
            case 6:
                self.currentMonthLbl.text = "July"
            case 7:
                self.currentMonthLbl.text = "August"
            case 8:
                self.currentMonthLbl.text = "September"
            case 9:
                self.currentMonthLbl.text = "October"
            case 10:
                self.currentMonthLbl.text = "November"
            case 11:
                self.currentMonthLbl.text = "December"
            default:
                print("Not working")
        }
        
        self.monthCollection.reloadData()
        getData(month: self.currentMonthIndex)
    }
    
    func getData(month: Int?) {
        guard self.currentMonthIndex != nil else { return }
        guard self.currentYear != nil else { return }
        
        self.todaysEvents = []
        self.monthEvents = []
        
        firestoreServices.shared.getEventsInMonth(vc: self, month: month ?? self.currentMonthIndex!, year: self.currentYear!) { (events) in
            self.monthEvents = events
            
            let today = Date()
            let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: today)
            let day = calanderDate.day
            self.todaysEvents = events.filter { Calendar.current.dateComponents([.day, .year, .month], from: $0.startTime).day == day }
            
            self.eventsTable.reloadData()
        }
    }
    
    func setMonthLbl(month: Int) {
        guard self.currentYear != nil else { return }
            
        switch month {
            case 0:
                self.currentMonthLbl.text = "January \(self.currentYear!)"
            case 1:
                self.currentMonthLbl.text = "Febuary \(self.currentYear!)"
            case 2:
                self.currentMonthLbl.text = "March \(self.currentYear!)"
            case 3:
                self.currentMonthLbl.text = "April \(self.currentYear!)"
            case 4:
                self.currentMonthLbl.text = "May \(self.currentYear!)"
            case 5:
                self.currentMonthLbl.text = "June \(self.currentYear!)"
            case 6:
                self.currentMonthLbl.text = "July \(self.currentYear!)"
            case 7:
                self.currentMonthLbl.text = "August \(self.currentYear!)"
            case 8:
                self.currentMonthLbl.text = "September \(self.currentYear!)"
            case 9:
                self.currentMonthLbl.text = "October \(self.currentYear!)"
            case 10:
                self.currentMonthLbl.text = "November \(self.currentYear!)"
            case 11:
                self.currentMonthLbl.text = "December \(self.currentYear!)"
            default:
                print("Not working")
        }
    }
    
    func setDays() {
        self.daysArray = []
        for n in 1...self.daysInMonth[currentMonthIndex ?? 0] {
            self.daysArray.append(n)
        }
    }
    
    @IBAction func addEvent(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "newEvent") as! newEventViewController
        newVC.delegate = self
        self.present(newVC, animated: true)
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        //SEGUE ANIMATION TO NEXT MONTH
        guard self.currentYear != nil else { return }
        
        for cells in self.monthCollection.visibleCells {
            cells.contentView.backgroundColor = .darkGray
        }
        
        UIView.animate(withDuration: 0.5) {
            self.monthCollection.transform = CGAffineTransform(translationX: -500, y: 0)
        } completion: { (true) in
            if self.currentMonthIndex != 11 {
                self.currentMonthIndex? += 1
                self.setDays()
                self.getData(month: self.currentMonthIndex!)
                self.setMonthLbl(month: self.currentMonthIndex!)
            } else {
                self.currentYear! += 1
                self.currentMonthIndex? = 0
                self.setDays()
                self.getData(month: self.currentMonthIndex)
                self.setMonthLbl(month: 0)
            }
            
            self.monthCollection.transform = CGAffineTransform(translationX: 500, y: 0)
            self.monthCollection.reloadData()
            
            UIView.animate(withDuration: 0.25) {
                self.monthCollection.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }
        
        for cells in self.monthCollection.visibleCells {
            cells.contentView.backgroundColor = .darkGray
        }
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        //SEGUE ANIMATION TO PREVIOUS MONTH
        guard self.currentYear != nil else { return }
        
        for cells in self.monthCollection.visibleCells {
            cells.contentView.backgroundColor = .darkGray
        }
        
        UIView.animate(withDuration: 0.25) {
            self.monthCollection.transform = CGAffineTransform(translationX: 500, y: 0)
        } completion: { (true) in
            if self.currentMonthIndex != 0 {
                self.currentMonthIndex? -= 1
                self.setDays()
                self.getData(month: self.currentMonthIndex)
                self.setMonthLbl(month: self.currentMonthIndex!)
            } else {
                self.currentYear! -= 1
                self.currentMonthIndex = 11
                self.setDays()
                self.getData(month: 11)
                self.setMonthLbl(month: 11)
            }
            
            self.monthCollection.transform = CGAffineTransform(translationX: -500, y: 0)
            self.monthCollection.reloadData()
            
            UIView.animate(withDuration: 0.5) {
                self.monthCollection.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }
    }
}

extension scheduleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 35, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.daysInMonth[currentMonthIndex ?? 0]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! dateCollectionViewCell
        
        let today = Date()
        let selectedDay = self.daysArray[indexPath.row]
        self.currentDayIndex = selectedDay
        let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: today)

        cell.contentView.layer.cornerRadius = cell.frame.height/2
        cell.setCell(day: self.daysArray[indexPath.row])
        
        if self.currentDayIndex! == calanderDate.day && calanderDate.year == self.currentYear! && calanderDate.month == self.currentMonthIndex! + 1 {
            cell.contentView.backgroundColor = .lightGray
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let today = Date()
        let selectedDay = self.daysArray[indexPath.row]
        self.currentDayIndex = selectedDay
        
        let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: today)

        if self.currentDayIndex! == calanderDate.day && calanderDate.year == self.currentYear! && calanderDate.month == self.currentMonthIndex! + 1 {
            self.eventsListTitleLbl.text = "Today's Events"
        } else {
            self.eventsListTitleLbl.text = "\(self.currentMonthIndex! + 1)/\(self.currentDayIndex!)/\(self.currentYear!)"
        }
        
        let currentCell = collectionView.cellForItem(at: indexPath)

        for cells in collectionView.visibleCells {
            cells.contentView.backgroundColor = self.settingTintColor
        }
        
        currentCell!.contentView.backgroundColor = .lightGray
        
        self.todaysEvents = self.monthEvents.filter { Calendar.current.dateComponents([.day, .year, .month], from: $0.startTime).day == selectedDay }
        self.eventsTable.reloadData()
        
    }
    
}

extension scheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todaysEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! eventTableViewCell
        let currentEvent = self.todaysEvents[indexPath.row]
        cell.setCell(event: currentEvent)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension scheduleViewController: newEventViewControllerDelegate {
    
    func didAddEvent() {
        self.viewDidAppear(true)
    }
    
}

