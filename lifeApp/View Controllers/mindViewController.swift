//
//  FirstViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 11/4/19.
//  Copyright © 2019 Charles Oxendine. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MapKit
import Purchases

class mindViewController: UIViewController {

    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var greeting: UILabel!
    @IBOutlet weak var todayAtGlanceTable: UITableView!
    @IBOutlet weak var newsTable: UITableView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var yourCityLabel: UILabel!
    @IBOutlet weak var weatherIMG: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    
    var currentLoc: CLLocation?
    var locationManager: CLLocationManager!
    var topStories: [newsStoryObject] = []
    
    var todayTasks: [task] = []
    var dayEvents: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        self.newsTable.delegate = self
        self.newsTable.dataSource = self
              
        self.todayAtGlanceTable.dataSource = self
        self.todayAtGlanceTable.delegate = self
        
        setDayAtGlance()
        
        getWeatherData()
        getNewsData()
        formatView()
        setTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //checkUser()
        setTheme()
        self.setDayAtGlance()
    }
    
    func setTheme() {
        switch _userServices.shared.currentUser.themeColor {
        case 0:
            self.weatherIMG.tintColor = themeUIColor().darkGray
            self.settingsButton.tintColor = themeUIColor().darkGray
        case 1:
            self.weatherIMG.tintColor = themeUIColor().pinkRed
            self.settingsButton.tintColor = themeUIColor().pinkRed
        case 2:
            self.weatherIMG.tintColor = themeUIColor().green
            self.settingsButton.tintColor = themeUIColor().green
        case 3:
            self.weatherIMG.tintColor = themeUIColor().blue
            self.settingsButton.tintColor = themeUIColor().blue
        case 4:
            self.weatherIMG.tintColor = themeUIColor().banana
            self.settingsButton.tintColor = themeUIColor().banana
        case 5:
            self.weatherIMG.tintColor = themeUIColor().darkTeal
            self.settingsButton.tintColor = themeUIColor().darkTeal
        default:
            self.weatherIMG.tintColor = themeUIColor().darkGray
            self.settingsButton.tintColor = themeUIColor().darkGray
        }
    }
    
    func checkUser() {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if purchaserInfo?.entitlements.all["pro-access"]?.isActive == true {
                print("[PURCHASES] - User entitlement is active")
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newVC = storyboard.instantiateViewController(identifier: "purchases") as? upgradePlanViewController
                newVC?.modalPresentationStyle = .fullScreen
                self.present(newVC!, animated: true)
            }
        }
    }
    
    func setDayAtGlance() {
        let today = Date()
        let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: today)
        let month = calanderDate.month
        let year = calanderDate.year
        let day = calanderDate.day
        
        firestoreServices.shared.getEventsInMonth(vc: self, month: month! - 1, year: year!) { (events) in
            self.dayEvents = _userServices.shared.currentUser.todayEvents
            self.todayTasks = _userServices.shared.currentUser.tasks.filter { Calendar.current.compare(Date(), to: $0.dueDate.dateValue(), toGranularity: .day) == ComparisonResult.orderedSame }
            
            self.todayAtGlanceTable.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setTheme()
    }
    
    func formatView() {
        
        //Set user name for greeting
        greeting.text = "Hello \(_userServices.shared.currentUser.name ?? "user")!"
        
        //Set date
        let currentDate = Date()
        let dateString = Utilities.formatDate(date: currentDate)
        currentDateLabel.text = "Today's Date: \(dateString)"
        
    }
    
    func getWeatherData() {
        guard currentLoc != nil else { return }
        
        weatherServices.shared.getCurrentWeatherStatus(vc: self, location: self.currentLoc!) { (weatherObject) in
            if weatherObject != nil {
                DispatchQueue.main.async {
                    self.tempLabel.text = String("\(Int(round(Utilities.kelvinToFahrenheit(kelvin: weatherObject!.temperature!))))°")
                    self.yourCityLabel.text = weatherObject!.cityName
                    
                    switch weatherObject!.weatherCode! {
                        case "01d":
                            self.weatherIMG.image = weatherServices.shared.sunImage()
                        case "01n":
                            self.weatherIMG.image = weatherServices.shared.sunImage()
                        case "02d":
                            self.weatherIMG.image = weatherServices.shared.cloudySunImage()
                        case "02n":
                            self.weatherIMG.image = weatherServices.shared.cloudyMoonImage()
                        case "03d":
                            self.weatherIMG.image = weatherServices.shared.cloudy()
                        case "03n":
                            self.weatherIMG.image = weatherServices.shared.cloudy()
                        case "04d":
                            self.weatherIMG.image = weatherServices.shared.cloudy()
                        case "04n":
                            self.weatherIMG.image = weatherServices.shared.cloudy()
                        case "09d":
                            self.weatherIMG.image = weatherServices.shared.heavyRain()
                        case "09n":
                            self.weatherIMG.image = weatherServices.shared.heavyRain()
                        case "10d":
                            self.weatherIMG.image = weatherServices.shared.cloudySunImage()
                        case "10n":
                            self.weatherIMG.image = weatherServices.shared.cloudyMoonImage()
                        case "11d":
                            self.weatherIMG.image = weatherServices.shared.boltRainImage()
                        case "11n":
                            self.weatherIMG.image = weatherServices.shared.boltRainImage()
                        case "13d":
                            self.weatherIMG.image = weatherServices.shared.snowImage()
                        case "13n":
                            self.weatherIMG.image = weatherServices.shared.snowImage()
                        case "50d":
                            self.weatherIMG.image = weatherServices.shared.cloudy()
                        case "50n":
                            self.weatherIMG.image = weatherServices.shared.cloudy()
                        default:
                            print("This shouldn't be happening")
                    }
                }
            }
        }
    }
    
    func getNewsData() {
        newsServices.shared.getTopStories(vc: self) { (stories) in
            if stories != nil {
                self.topStories = stories!
                DispatchQueue.main.async {
                    self.newsTable.reloadData()
                }
            }
        }
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "settings") as! settingsViewController
        newVC.delegate = self
        self.present(newVC, animated: true)
    }
    
}

extension mindViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLoc = manager.location
        getWeatherData()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.currentLoc = manager.location
        getWeatherData()
    }
    
}

extension mindViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.newsTable {
            return self.topStories.count
        } else {
            return Int(self.todayTasks.count + self.dayEvents.count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.newsTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsStory") as? newsStoryTableViewCell
            let currentStory = self.topStories[indexPath.row]
            cell?.setCell(story: currentStory)
            return cell!
        } else {
            if indexPath.row < self.dayEvents.count {
                let currentDayEvent = self.dayEvents[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as? eventTableViewCell
                cell?.setCell(event: currentDayEvent)
                return cell!
            } else {
                let index = indexPath.row - self.dayEvents.count
                let currentDayTask = self.todayTasks[index]
                let cell = tableView.dequeueReusableCell(withIdentifier: "task") as? taskTableViewCell
                cell?.setCell(task: currentDayTask)
                return cell!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.newsTable {
            return 150
        } else {
            if indexPath.row < self.dayEvents.count {
                return 80
            } else {
                return 65
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == self.newsTable {
            let currentStory = self.topStories[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(identifier: "webView") as! webViewController
            newVC.webURL = currentStory.urlToArticle as URL?
            self.present(newVC, animated: true)
        } else {
            if indexPath.row < self.dayEvents.count {
                let currentDayEvents = self.dayEvents[indexPath.row]
            } else {
                let index = indexPath.row - self.dayEvents.count
                let currentDayTasks = self.todayTasks[index]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == self.newsTable {
            return nil
        } else {
            if indexPath.row < self.dayEvents.count {
                let currentDayEvents = self.dayEvents[indexPath.row]
            } else {
                let detailView = UIContextualAction(style: .destructive, title: "Details") { (action, sourceView, completionHandler) in
                    let index = indexPath.row - self.dayEvents.count
                    let currentTask = self.todayTasks[index]
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let newVC = storyboard.instantiateViewController(withIdentifier: "taskDetail") as! taskDetailViewController
                    newVC.delegate = self
                    newVC.currentTaskID = currentTask.id
                    self.present(newVC, animated: true, completion: nil)
                }
                
                let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, sourceView, completionHandler) in
                    let alert = UIAlertController(title: "Are you sure?", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
                    let yes = UIAlertAction(title: "Delete", style: .default) { (action) in
                        let index = indexPath.row - self.dayEvents.count
                        let currentTask = self.todayTasks[index]
                        firestoreServices.shared.deleteTask(taskID: currentTask.id!) { (err) in
                            if err != nil {
                                Utilities.errMessage(message: err!, view: self)
                                return
                            }
                            
                            self.setDayAtGlance()
                        }
                    }
                    
                    let no = UIAlertAction(title: "No", style: .default)
                    
                    alert.addAction(yes)
                    alert.addAction(no)
                    self.present(alert, animated: true)
                }
                
                deleteAction.backgroundColor = .red
                detailView.backgroundColor = .darkGray
                
                let swipeActionConfig = UISwipeActionsConfiguration(actions: [detailView, deleteAction])
                swipeActionConfig.performsFirstActionWithFullSwipe = false
                return swipeActionConfig
            }
        }
        
        return nil
    }
}

extension mindViewController: settingsViewControllerDelegate, taskDetailViewControllerDelegate {
    
    func didCloseView() {
        self.setDayAtGlance()
    }
    
    
    func updatedThemeColor() {
        self.setTheme()
    }
    
}


