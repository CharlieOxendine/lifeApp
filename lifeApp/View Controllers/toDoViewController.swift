//
//  toDoViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 11/4/19.
//  Copyright © 2019 Charles Oxendine. All rights reserved.
//

import UIKit
import FirebaseFirestore

class toDoViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var todayTableView: UITableView! //Top
    @IBOutlet weak var weekTableView: UITableView! //Bottom
    
    var tasks: [ task ] = []
    var todayTasks: [ task ] = []
    
    var count1 = 0
    var count2 = 0
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        
        self.tasks.removeAll()
        self.todayTasks.removeAll()
    
        getTasks()
        super.viewDidLoad()
        
        //Set Delegates and DataSources for Table Views
        todayTableView.delegate = self
        todayTableView.dataSource = self
        weekTableView.delegate = self
        weekTableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.weekTableView.reloadData()
        self.todayTableView.reloadData()
    }
    
    func getTasks() {
        _userServices.shared.currentUser.getTasks { (success) in
            if success == true {
                
                self.tasks = []
                self.todayTasks = []
                
                let today = Date()
                let weekFromNow = today.advanced(by: TimeInterval(604800))
               
                for task in _userServices.shared.currentUser.tasks {
                    
                    let dueDate = task.dueDate.dateValue()
                    
                    if (Calendar.current.isDateInToday(task.dueDate.dateValue())) {
                        self.todayTasks.append(task)
                    } else if dueDate <= weekFromNow {
                        self.tasks.append(task)
                    }
                }
                
                self.weekTableView.reloadData()
                self.todayTableView.reloadData()
            }
        }
    }
    
    @IBAction func newTaskTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "newTask") as! newTaskViewController
        newVC.delegate = self
        self.present(newVC, animated: true)
    }
    
}


// MARK: - Extension
extension toDoViewController: UITableViewDelegate, UITableViewDataSource, taskTableViewCellDelegate {
    
    func reloadData() {
        self.getTasks()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == todayTableView {
            return todayTasks.count
        } else if tableView == weekTableView {
            return tasks.count
        } else {
            return 0
        }
    }
    
    // MARK: Cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task") as! taskTableViewCell
        
        cell.delegate = self
        
        //add data for TOP TABLE VIEW CELL
        if tableView == todayTableView {
            cell.setCell(task: self.todayTasks[indexPath.row])
            return cell
        //add data for BOTTOM TABLE VIEW CELL
        } else if tableView == weekTableView {
            cell.setCell(task: self.tasks[indexPath.row])
            return cell
        } else {
            return cell
        }
    }
    
    // MARK: Did select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var currentTask: task!
        if tableView == self.todayTableView {
            currentTask = self.todayTasks[indexPath.row]
        } else {
            currentTask = self.tasks[indexPath.row]
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "taskDetail") as! taskDetailViewController
        newVC.delegate = self
        newVC.currentTask = currentTask
        newVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(newVC, animated: true, completion: nil)
        return
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    // MARK: Swipe Buttons on Table Cell
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == weekTableView {
            let currentTask = self.tasks[indexPath.row]
            let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, sourceView, completionHandler) in
                let alert = UIAlertController(title: "Are you sure?", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
                let yes = UIAlertAction(title: "Delete", style: .default) { (action) in
                    firestoreServices.shared.deleteTask(taskID: currentTask.id!) { (err) in
                        if err != nil {
                            Utilities.errMessage(message: err!, view: self)
                            return
                        }
                        
                        self.getTasks()
                    }
                }
                
                let no = UIAlertAction(title: "No", style: .default)
                
                alert.addAction(yes)
                alert.addAction(no)
                self.present(alert, animated: true)
            }
            
            deleteAction.backgroundColor = .red
            
            let swipeActionConfig = UISwipeActionsConfiguration(actions: [deleteAction])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
            return swipeActionConfig
        } else {
            
            let currentTask = self.todayTasks[indexPath.row]
        
            let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, sourceView, completionHandler) in
                let alert = UIAlertController(title: "Are you sure?", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
                let yes = UIAlertAction(title: "Delete", style: .default) { (action) in
                    firestoreServices.shared.deleteTask(taskID: currentTask.id!) { (err) in
                        if err != nil {
                            Utilities.errMessage(message: err!, view: self)
                            return
                        }
                        
                        self.getTasks()
                    }
                }
                
                let no = UIAlertAction(title: "No", style: .default)
                
                alert.addAction(yes)
                alert.addAction(no)
                self.present(alert, animated: true)
            }
            
            deleteAction.backgroundColor = .red
            
            let swipeActionConfig = UISwipeActionsConfiguration(actions: [deleteAction])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
            return swipeActionConfig
            
        }
    }
}

extension toDoViewController: taskDetailViewControllerDelegate, newTaskViewControllerDelegate {
    func viewClosed() {
        self.getTasks()
    }
    
    func didCloseView() {
        self.getTasks()
    }

}
