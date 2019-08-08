//
//  AppPurchaseViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 3/28/19.
//  Copyright © 2019 Mikael Olezeski. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

class AppPurchaseViewController: DesignOfViewController {
    
    @IBOutlet weak var upgradeButton: UIButton!
    
    @IBAction func upgradeButtonPressed(_ sender: UIButton) {
        SpellProducts.store.buyProduct(products[0])
    }
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var detailText: UILabel!
    fileprivate var productIDs: [String] = []
    fileprivate var productArray: [SKProduct] = []
    @IBOutlet weak var restoreButton: UIButton!
    
    var products: [SKProduct] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    SpellProducts.store.requestProducts{ [weak self] success, products in
        guard let self = self else { return }
        if success {
            self.products = products!
            
        }
    }
        SpellProducts.store.productDidPurchased = { [weak self] in
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        
        // Set UI
        upgradeButton.backgroundColor = Constants.buttonColor
        navigationItem.backBarButtonItem?.tintColor = Constants.buttonColor
        headerText.textColor = Constants.textColor
        detailText.textColor = Constants.textColor
        restoreButton.titleLabel?.textColor = Constants.textColor
        
        
        if !(IAPHelper.canMakePayments()) {
            headerText.text = "Purchases not available at this time"
            detailText.text = ""
            upgradeButton.isHidden = true
        }

    }
    
    @IBAction func restoreButtonPressed(_ sender: Any) {
        SpellProducts.store.restorePurchases()
        self.dismiss(animated: true, completion: nil)
    }

    
    
    
    
}
