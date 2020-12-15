//
//  upgradePlanViewController.swift
//  lifeApp
//
//  Created by Charles Oxendine on 12/14/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import UIKit
import Purchases

class upgradePlanViewController: UIViewController {

    @IBOutlet weak var currentPlanLbl: UILabel!
    @IBOutlet weak var currentPlanIndicator: UILabel!
    
    @IBOutlet weak var upgradeCallToActionLbl: UILabel!
    
    @IBOutlet weak var yearlyPlanButton: UIView!
    @IBOutlet weak var monthlyPlanButton: UIView!
        
    private var monthlyPackage: Purchases.Package?
    private var yearlyPackage: Purchases.Package?
      
    var introPopup: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCurrentStatus()
        noSubscriptionSetup()
        
        setUI()
    }

    func setUI() {
        self.monthlyPlanButton.layer.cornerRadius = 20
        self.yearlyPlanButton.layer.cornerRadius = 20
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
    }
    
    func activeSubscriptionSetup() {
        self.currentPlanLbl.isHidden = false
        self.currentPlanIndicator.isHidden = false
        self.upgradeCallToActionLbl.isHidden = true
    }
    
    @IBAction func yearlyTapped(_ sender: Any) {
        guard self.yearlyPackage != nil else { return }
        Purchases.shared.purchasePackage(self.yearlyPackage!) { (transaction, purchaserInfo, err, userCancelled) in
            if purchaserInfo?.entitlements.all["pro-access"]?.isActive == true {
                print("Worked")
            }
        }
    }
    
    @IBAction func monthlyTapped(_ sender: Any) {
        guard self.monthlyPackage != nil else { return }
        Purchases.shared.purchasePackage(self.monthlyPackage!) { (transaction, purchaserInfo, err, userCancelled) in
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
