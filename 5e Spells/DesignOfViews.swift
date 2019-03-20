//
//  DesignOfViews.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 8/2/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class DesignOfTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navCon = navigationController {
            navCon.navigationBar.barTintColor = Constants.barColor
            navCon.navigationBar.titleTextAttributes = Constants.textAttributes
            navCon.navigationBar.largeTitleTextAttributes = Constants.textAttributes
            navCon.navigationBar.tintColor =  Constants.navButtonColor
        }
    }
    
    
}

class DesignOfViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navCon = navigationController {
            navCon.navigationBar.barTintColor = Constants.barColor
            navCon.navigationBar.titleTextAttributes = Constants.textAttributes
            navCon.navigationBar.largeTitleTextAttributes = Constants.textAttributes
            navCon.navigationBar.tintColor = Constants.navButtonColor
        }
    }
}

class DesignOfTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navCon = navigationController {
            navCon.navigationBar.barTintColor = Constants.barColor
            navCon.navigationBar.titleTextAttributes = Constants.textAttributes
            navCon.navigationBar.largeTitleTextAttributes = Constants.textAttributes
           navCon.navigationBar.tintColor = Constants.navButtonColor

        }
        tabBar.barTintColor = Constants.barColor
        tabBar.unselectedItemTintColor = UIColor.white
        tabBar.tintColor = Constants.buttonColor
    }
}

