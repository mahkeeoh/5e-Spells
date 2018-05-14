//
//  SpellDetailViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/22/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class SpellDetailViewController: UIViewController {
    
    
    // Setup all outlets
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
        
        // add components and include materials if applicable
        components.text = (spell?.components)
        if (spell?.material != nil) {
            addMaterials()
        }
        
        // add duration and concentration symbol if applicable
        duration.text = (spell?.duration)
        if (spell?.concentration == "yes") {
            duration.text = duration.text! + "  \u{00A9}"
        }
        spellDescription.text = "Description: " + (spell?.desc)!
        if spell?.higherLevel != nil {
            higherLevels.text = "Higher Level: " + (spell?.higherLevel)!
        }
    }
    
    func addMaterials() {
       // let attribute = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 10.0)]
       // let materialText = NSAttributedString(string: (spell?.material)!, attributes: attribute)
        let materialText = spell?.material
        components.text = components.text! + "*\n" + materialText!

    }

}
