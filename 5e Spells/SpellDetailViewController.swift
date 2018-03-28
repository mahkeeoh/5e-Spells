//
//  SpellDetailViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/22/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class SpellDetailViewController: UIViewController {
    
    @IBOutlet weak var spellTitle: UILabel!
    @IBOutlet weak var levelAndSpellType: UILabel!
    @IBOutlet weak var castingTime: UILabel!
    @IBOutlet weak var range: UILabel!
    @IBOutlet weak var components: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var spellDescription: UILabel!
    @IBOutlet weak var higherLevels: UILabel!
    
    var spell: Spell? {
        didSet {
            // Fix text from JSON to remove paragraph markers
            let tempSpellDesc = (spell?.desc.replacingOccurrences(of: "<p>", with: "\n\n"))!.replacingOccurrences(of: "</p>", with: "")
            spell?.desc = tempSpellDesc
            
            let tempSpellHLDesc = (spell?.higherLevel?.replacingOccurrences(of: "<p>", with: "\n\n"))?.replacingOccurrences(of: "</p>", with: "")
            spell?.higherLevel = tempSpellHLDesc
        
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupText()

    }
    
    func setupText() {
        spellTitle.text = (spell?.name)
        levelAndSpellType.text = (spell?.level)! + ", " + (spell?.school)!
        castingTime.text = (spell?.castingTime)
        range.text = (spell?.range)
        components.text = (spell?.components)
        duration.text = (spell?.duration)
        spellDescription.text = (spell?.desc)
        higherLevels.text = (spell?.higherLevel)
       // spellDescription.text = (spell?.desc.replacingOccurrences(of: "<p>", with: "\n"))!
        //spellDescription.text = spell?.desc
        print(spellDescription.text!)
    }

}
