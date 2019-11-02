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
           /* navCon.navigationBar.barTintColor = Constants.barColor
            navCon.navigationBar.titleTextAttributes = Constants.textAttributes
            navCon.navigationBar.largeTitleTextAttributes = Constants.textAttributes
            navCon.navigationBar.tintColor =  Constants.navButtonColor*/
            
            let navBarAppearance = UINavigationBarAppearance()
           // navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.configureWithDefaultBackground()
                navBarAppearance.titleTextAttributes = Constants.textAttributes
            navBarAppearance.largeTitleTextAttributes = Constants.textAttributes
            navBarAppearance.backgroundColor = Constants.barColor
            navCon.navigationBar.standardAppearance = navBarAppearance
            navCon.navigationBar.scrollEdgeAppearance = navBarAppearance

        }
        // overrideUserInterfaceStyle is available with iOS 13
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
    }

    
}

class DesignOfViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navCon = navigationController {
            /*navCon.navigationBar.barTintColor = Constants.barColor
            navCon.navigationBar.titleTextAttributes = Constants.textAttributes
            navCon.navigationBar.largeTitleTextAttributes = Constants.textAttributes
            navCon.navigationBar.tintColor = Constants.navButtonColor*/
            
            let navBarAppearance = UINavigationBarAppearance()
            // navBarAppearance.configureWithOpaqueBackground()
             navBarAppearance.configureWithDefaultBackground()
            navBarAppearance.titleTextAttributes = Constants.textAttributes
            navBarAppearance.largeTitleTextAttributes = Constants.textAttributes
            navBarAppearance.backgroundColor = Constants.barColor
            navCon.navigationBar.standardAppearance = navBarAppearance
            navCon.navigationBar.scrollEdgeAppearance = navBarAppearance

        }
        
        // overrideUserInterfaceStyle is available with iOS 13
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
    }
}

class DesignOfTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navCon = navigationController {
            /*navCon.navigationBar.barTintColor = Constants.barColor
            navCon.navigationBar.titleTextAttributes = Constants.textAttributes
            navCon.navigationBar.largeTitleTextAttributes = Constants.textAttributes
           navCon.navigationBar.tintColor = Constants.navButtonColor*/
            
            let navBarAppearance = UINavigationBarAppearance()
                      // navBarAppearance.configureWithOpaqueBackground()
             navBarAppearance.configureWithDefaultBackground()
            navBarAppearance.titleTextAttributes = Constants.textAttributes
            navBarAppearance.largeTitleTextAttributes = Constants.textAttributes
            navBarAppearance.backgroundColor = Constants.barColor
            navCon.navigationBar.standardAppearance = navBarAppearance
            navCon.navigationBar.scrollEdgeAppearance = navBarAppearance



        }
        
        
        tabBar.barTintColor = Constants.tabColor
       // tabBar.unselectedItemTintColor = UIColor.white
        tabBar.unselectedItemTintColor = Constants.textColor
        tabBar.tintColor = Constants.buttonColor
        
        // overrideUserInterfaceStyle is available with iOS 13
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
    }
}

