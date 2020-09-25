//
//  weatherServices.swift
//  lifeApp
//
//  Created by Charles Oxendine on 9/3/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import Foundation
import MapKit

class weatherServices {
    
    let weatherAPIKey = "4d93373254da15ef7fc7624a48e1de16"
    
    public static let shared = weatherServices()
    
    // MARK: Weather Functions
    func getCurrentWeatherStatus(vc: UIViewController, location: CLLocation, completion: @escaping (weatherObject?) -> ()) {
        let session = URLSession(configuration: .default)
        
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(weatherAPIKey)") else {
            print("Error creating URL")
            return
        }
        
        let task = session.dataTask(with: url) { (data, res, err) in
            if err != nil {
                DispatchQueue.main.async { Utilities.errMessage(message: err!.localizedDescription, view: vc) }
                return
            }
            
            guard data != nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                completion(self.getWeatherData(weatherJSON: json!))
            } catch {
                print("Could Not Parse Data")
                completion(nil)
            }
            
        }
        
        task.resume()
    }
    
    func getWeatherData(weatherJSON: [String: Any]) -> weatherObject {
        let main = weatherJSON["main"] as? [String: Any]
        let weather = weatherJSON["weather"] as? [[String: Any]]
        
        let temp = main?["temp"] as? Double
        let cityName = weatherJSON["name"] as? String
        let desc = weather?[0]["icon"] as? String
        
        let object = weatherObject(temperature: temp, weatherCode: desc, cityName: cityName)
        return object
    }
    
    // MARK: Icons for different Weather Types
    var boltRainImage = {
        return UIImage(systemName: "cloud.bolt.rain")
    }
    
    var sunImage = {
        return UIImage(systemName: "sun.max")
    }
    
    var cloudySunImage = {
        return UIImage(systemName: "cloud.sun")
    }
    
    var cloudyMoonImage = {
        return UIImage(systemName: "cloud.moon")
    }
    
    var lightDayRainImage = {
        return UIImage(systemName: "cloud.sun.rain")
    }
    
    var lightNightRainImage = {
        return UIImage(systemName: "cloud.moon.rain")
    }
    
    var snowImage = {
        return UIImage(systemName: "snow")
    }
    
    var cloudy = {
        return UIImage(systemName: "cloud")
    }
    
    var heavyRain = {
        return UIImage(systemName: "cloud.rain")
    }
    
}

struct weatherObject {
    var temperature: Double? //Kelvin
    var weatherCode: String? //Cooresponds to icon that tells us what icon to use for this weather
    var cityName: String?
}

