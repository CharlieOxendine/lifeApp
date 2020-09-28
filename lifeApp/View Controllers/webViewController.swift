//
//  webViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 9/27/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import UIKit
import WebKit

class webViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var closeViewButton: UIButton!
    
    var webURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: webURL!))
        setView()
    }
    
    func setView() {
        self.closeViewButton.layer.cornerRadius = self.closeViewButton.frame.height/2
    }

    @IBAction func closeViewTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
