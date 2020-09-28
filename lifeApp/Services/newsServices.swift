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
            var storyObjects: [newsStoryObject] = []
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                
                if let articles = json?["articles"] as? [[String: Any]] {
                    for stories in articles {
                        let storyObject = self.getStoryObject(story: stories)
                        storyObjects.append(storyObject)
                    }
                    
                    completion(storyObjects)
                }
                
            } catch {
                Utilities.errMessage(message: "Could Not Parse Data", view: vc)
            }
        }
        
        task.resume()
    }
    
    func stringToDate(dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateStr)!
        return date
    }
    
    func getStoryObject(story: [String: Any]) -> newsStoryObject {
        let source = story["source"] as? [String: Any]
        
        let sourceName = (source?["name"] as? String) ?? ""
        let storyTitle = (story["title"] as? String) ?? ""
        let author = story["author"] as? String ?? ""
        let description = story["description"] as? String ?? ""
        let urlRaw = story["url"] as? String ?? ""
        let urlIMGRaw = story["urlToImage"] as? String ?? ""
        let publishedDateString = story["publishedAt"] as? String
        
        let url = NSURL(string: urlRaw)
        let urlIMG = NSURL(string: urlIMGRaw)
        
        let publishedDate = self.stringToDate(dateStr: publishedDateString ?? "")
        
        let storyObject = newsStoryObject(title: storyTitle, author: author, description: description, urlToArticle: url, urlIMG: urlIMG, publishedDate: publishedDate, publisher: sourceName)
        return storyObject
    }
    
}

protocol newsStoryObjectDelegate: AnyObject {
    func imageRecieved(image: UIImage)
}

class newsStoryObject {
    
    var title: String!
    var author: String!
    var description: String!
    var urlToArticle: NSURL!
    var urlIMG: NSURL?
    var publishedDate: Date?
    var publisher: String?
    var articleIMG: UIImage?

    var delegate: newsStoryObjectDelegate?
    
    init(title: String, author: String, description: String, urlToArticle: NSURL?, urlIMG: NSURL?, publishedDate: Date, publisher: String) {
        self.title = title
        self.author = author
        self.description = description
        self.urlToArticle = urlToArticle
        self.urlIMG = urlIMG
        self.publishedDate = publishedDate
        self.publisher = publisher
        
        getIMG()
    }
    
    func getIMG() {
        if urlIMG != nil {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: self.urlIMG! as URL) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.articleIMG = image
                            if self.articleIMG != nil {
                                self.delegate?.imageRecieved(image: self.articleIMG!)
                            }
                        }
                    }
                }
            }
        }
    }
}
