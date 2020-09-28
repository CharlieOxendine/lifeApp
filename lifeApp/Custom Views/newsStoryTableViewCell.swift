//
//  newsStoryTableViewCell.swift
//  lifeApp
//
//  Created by Charles Oxendine on 9/25/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import UIKit

class newsStoryTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var publishedDateLbl: UILabel!
    @IBOutlet weak var publisherLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCell(story: newsStoryObject) {
        story.delegate = self
        self.titleLbl.text = story.title
        self.publisherLbl.text = story.publisher
        self.publishedDateLbl.text = "\(story.publishedDate!.timeAgo()) ago"
        
        if story.articleIMG != nil {
            self.articleImage.image = story.articleIMG
        } else {
            self.articleImage.image = UIImage(named: "news")
        }
    }
    
}

extension newsStoryTableViewCell: newsStoryObjectDelegate {
    
    func imageRecieved(image: UIImage) {
        DispatchQueue.main.async {
            self.articleImage.image = image
        }
    }
    
}
