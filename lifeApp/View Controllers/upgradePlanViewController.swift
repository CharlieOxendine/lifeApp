//
//  upgradePlanViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 12/14/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import UIKit
import Purchases
import NVActivityIndicatorView

class upgradePlanViewController: UIViewController {

    @IBOutlet weak var currentPlanLbl: UILabel!
    @IBOutlet weak var currentPlanIndicator: UILabel!
    
    @IBOutlet weak var upgradeCallToActionLbl: UILabel!
    
    @IBOutlet weak var yearlyPlanButton: UIView!
    @IBOutlet weak var monthlyPlanButton: UIView!
    @IBOutlet weak var tryItLbl: UILabel!
    
    var activityIndicatorObject: NVActivityIndicatorView?

    private var monthlyPackage: Purchases.Package?
    private var yearlyPackage: Purchases.Package?
      
    var introPopup: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCurrentStatus()
        noSubscriptionSetup()
        
        setLoadingIndicator()
        
        setUI()
    }

    func setUI() {
        self.monthlyPlanButton.layer.cornerRadius = 20
        self.yearlyPlanButton.layer.cornerRadius = 20
    }
    
    func setLoadingIndicator() {
        let center = self.view.center
        let rect = CGRect(x: center.x - 30, y: center.y - 30, width: 60, height: 60)
        
        let indicator = NVActivityIndicatorView(frame: rect, type: .circleStrokeSpin, color: .white)
        indicator.backgroundColor = .darkGray
        indicator.layer.cornerRadius = 15
        self.activityIndicatorObject = indicator
        self.view.addSubview(indicator)
    }
    
    func getCurrentStatus() {
        Purchases.shared.purchaserInfo { (purchaserInfo, err) in
            if purchaserInfo?.entitlements.all["pro-access"]?.isActive == true {
                self.activeSubscriptionSetup()
            } else {
                self.noSubscriptionSetup()
                Purchases.shared.offerings { (offerings, error) in
                    if let offerings = offerings {
                        guard offerings.current != nil else {
                            return
                        }
                        
                        let monthly = offerings.current!.monthly
                        let yearly = offerings.current!.annual
                        
                        self.monthlyPackage = monthly
                        self.yearlyPackage = yearly
                    }
                }
            }
        }
    }
    
    func noSubscriptionSetup() {
        self.currentPlanLbl.isHidden = true
        self.currentPlanIndicator.isHidden = true
        self.upgradeCallToActionLbl.isHidden = false
        self.tryItLbl.isHidden = false
    }
    
    func activeSubscriptionSetup() {
        self.currentPlanLbl.isHidden = false
        self.currentPlanIndicator.isHidden = false
        self.upgradeCallToActionLbl.isHidden = true
        self.tryItLbl.isHidden = true
    }
    
    @IBAction func yearlyTapped(_ sender: Any) {
        self.activityIndicatorObject?.startAnimating()
        guard self.yearlyPackage != nil else { return }
        Purchases.shared.purchasePackage(self.yearlyPackage!) { (transaction, purchaserInfo, err, userCancelled) in
            self.activityIndicatorObject?.stopAnimating()
            if purchaserInfo?.entitlements.all["pro-access"]?.isActive == true {
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func monthlyTapped(_ sender: Any) {
        self.activityIndicatorObject?.startAnimating()
        self.monthlyPlanButton.isUserInteractionEnabled = false
        self.yearlyPlanButton.isUserInteractionEnabled = false
        
        guard self.monthlyPackage != nil else { return }
        Purchases.shared.purchasePackage(self.monthlyPackage!) { (transaction, purchaserInfo, err, userCancelled) in
            self.activityIndicatorObject?.stopAnimating()
            self.monthlyPlanButton.isUserInteractionEnabled = true
            self.yearlyPlanButton.isUserInteractionEnabled = true
            if purchaserInfo?.entitlements.all["pro-access"]?.isActive == true {
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func restorePurchasesTapped(_ sender: Any) {
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            self.getCurrentStatus()
        }
    }
}
