//
//  SpellTabBarController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 3/3/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class SpellTabBarController: DesignOfTabBarController {
    
   // var character: Character?
    var index: Int!
    var characterModel: CharacterModelController!
    var classTabName: String!
    var isWizard = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set character model in both tab views
       // var isFirstVC = true
        var count = 0
        for viewController in viewControllers! {
            if let spellVC = viewController.content as? SpellsTableViewController {
                spellVC.character = characterModel.characters[index]
                
                switch count {
                case 0:
                    spellVC.title = classTabName
                    spellVC.tabBarController?.tabBar.items?[0].image = UIImage(named: "PreparedTabImage")
                case 1:
                    spellVC.title = "Spellbook"
                    spellVC.tabBarController?.tabBar.items?[1].image = UIImage(named: "SpellbookTabImage")
                default:
                    spellVC.title = "Class Spells"
                    spellVC.tabBarController?.tabBar.items?[2].image = UIImage(named: "ClassTabImage")
                }
                
                count += 1
            }
        }
        // remove middle tab unless class is wizard
        if !isWizard {
            viewControllers?.remove(at: 1)
        }
    }


}
