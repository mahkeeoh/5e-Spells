//
//  AppPurchaseViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 3/28/19.
//  Copyright © 2019 Mikael Olezeski. All rights reserved.
//

import Foundation
import UIKit

class AppPurchaseViewController: DesignOfViewController {
    
    @IBOutlet weak var upgradeButton: UIButton!
    @IBAction func upgradeButtonPressed(_ sender: UIButton) {
    
    }
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var detailText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upgradeButton.backgroundColor = Constants.buttonColor
        navigationItem.backBarButtonItem?.tintColor = Constants.buttonColor
        headerText.textColor = Constants.textColor
        detailText.textColor = Constants.textColor
    }
}
