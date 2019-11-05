//
//  toDoViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 11/4/19.
//  Copyright © 2019 Charles Oxendine. All rights reserved.
//

import UIKit

class toDoViewController: UIViewController {

    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var todayTableView: UITableView! //Top
    @IBOutlet weak var weekTableView: UITableView! //Bottom
    
    var tasks: Array<task> = []
    var userUID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todayTableView.delegate = self
        todayTableView.dataSource = self
        weekTableView.delegate = self
        weekTableView.dataSource = self
    }

    func formatView() {
        print("formatted view...")
    }
    
    @objc func printValue(notification:NSNotification) {
        let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
        let item = userInfo["value"]! as String

        print(item,self)
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    @IBAction func addTaskClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "createTask")
        self.present(newVC, animated: true)
    }
}

extension toDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath) as! taskTableViewCell
        
        //add data for TOP TABLE VIEW CELL
        if tableView == todayTableView {
            var time = Date()
            var dateString = formatDate(date: time)
            cell.currentDateLabel.text = dateString
            cell.titleLabel.text = "HEHEEEE"
            return cell
        
        //add data for BOTTOM TABLE VIEW CELL
        } else {
            var time = Date()
            var dateString = formatDate(date: time)
            cell.weekDateLabel.text = dateString
            cell.weekTitleLabel.text = "EHLLLOAJWD"
            return cell
        }
    }
}
