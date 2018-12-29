//
//  AppDelegate.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/15/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let characterVC = window?.rootViewController?.content as? CharacterViewController {
            characterVC.characterModel = CharacterModelController()
        }
        return true
    }


}

