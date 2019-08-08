//
//  AppDelegate.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/15/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var currentCount: Int?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let characterVC = window?.rootViewController?.content as? CharacterViewController {
            characterVC.characterModel = CharacterModelController()
        }
        
        
        // Setting up google ads
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // get current number of times app has been launched
        currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        
        // increment received number by one
        UserDefaults.standard.set(currentCount!+1, forKey:"launchCount")
        print(currentCount)
        
        return true
    }


}

