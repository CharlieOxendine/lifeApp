//
//  newsServices.swift
//  lifeApp
//
//  Created by Charles Oxendine on 9/24/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import Foundation
import UIKit

class newsServices {

    var newsAPIKey = "ae9b0fa75c6f48c29725bd9a02f6fc64"
    public static let shared = newsServices()
    
    func getTopStories(vc: UIViewController, completion: @escaping ([newsStoryObject]?) -> ()) {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(newsAPIKey)") else {
            print("Error creating URL")
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, res, err) in
            if err != nil {
                DispatchQueue.main.async { Utilities.errMessage(message: err!.localizedDescription, view: vc) }
                return
            }
            
            guard data != nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                
                if let articles = json?["articles"] as? [[String: Any]] {
                    for stories in articles {
                        print(stories)
                    }
                }
                
            } catch {
                print("Could Not Parse Data")
            }
        }
        
        task.resume()
    }
    
    func getStoryObject(story: [String: Any]) {
        
    }
    
}

struct newsStoryObject {
    
    var title: String!
    var author: String! 
}
