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
    
    var daysArray: [Int] = []
    var daysInMonth: [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 30, 31, 30]
    var currentMonthIndex: Int? //The current month index showing day in that month
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.monthCollection.delegate = self
        self.monthCollection.dataSource = self
        
        setCurrentMonth()
    }

    func setCurrentMonth() {
        let today = Date()
        let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: today)
        let month = calanderDate.month
        
        if month != nil { self.currentMonthIndex = month! - 1 }
        
        for n in 1...self.daysInMonth[currentMonthIndex ?? 0] {
            self.daysArray.append(n)
        }
        
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
        
        cell.setCell(day: self.daysArray[indexPath.row])
        return cell
    }
    
}

