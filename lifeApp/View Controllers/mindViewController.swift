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

class mindViewController: UIViewController {

    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var greeting: UILabel!
    @IBOutlet weak var todayAtGlanceTable: UITableView!
    @IBOutlet weak var bigGoalsTable: UITableView!
    @IBOutlet weak var newsTable: UITableView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var yourCityLabel: UILabel!
    @IBOutlet weak var weatherIMG: UIImageView!
    
    var currentLoc: CLLocation?
    var locationManager: CLLocationManager!
    var topStories: [newsStoryObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        getWeatherData()
        getNewsData()
        formatView()
    }
    
    func formatView() {
        
        //Set user name for greeting
        greeting.text = "Hello \(_userServices.shared.currentUser.name ?? "user")!"
        
        //Set date
        let currentDate = Date()
        let dateString = Utilities.formatDate(date: currentDate)
        currentDateLabel.text = "Today's Date: \(dateString)"
        
        //Set UI
        self.newsTable.layer.cornerRadius = 15
        self.newsTable.layer.borderWidth = 1
        self.newsTable.layer.borderColor = UIColor.darkGray.cgColor
        
        self.todayAtGlanceTable.layer.cornerRadius = 15
        self.todayAtGlanceTable.layer.borderWidth = 1
        self.todayAtGlanceTable.layer.borderColor = UIColor.darkGray.cgColor
        
        self.bigGoalsTable.layer.cornerRadius = 15
        self.bigGoalsTable.layer.borderWidth = 1
        self.bigGoalsTable.layer.borderColor = UIColor.darkGray.cgColor
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
            }
        }
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
