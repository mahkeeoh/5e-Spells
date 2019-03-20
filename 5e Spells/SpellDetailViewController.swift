//
//  SpellDetailViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/22/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class SpellDetailViewController: DesignOfViewController {
    
    
    // Setup all outlets
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
        title = spell?.name
        levelAndSpellType.textColor = Constants.textColor
        castingTime.textColor = Constants.textColor
        range.textColor = Constants.textColor
        components.textColor = Constants.textColor
        duration.textColor = Constants.textColor
        spellDescription.textColor = Constants.textColor
        higherLevels.textColor = Constants.textColor
    }
    
    func setupText() {
        
        // add bold format
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)]
        if (spell?.level == "Cantrip") {
            levelAndSpellType.text = (spell?.school)! + " " + (spell?.level)!
        }
        else {
            levelAndSpellType.text = (spell?.level)! + " " + (spell?.school)!
        }
        let castingTimeBold = NSMutableAttributedString(string: "Casting Time: ", attributes: attrs)
        let castingTimeText = NSMutableAttributedString(string: spell?.castingTime ?? "")
        castingTimeBold.append(castingTimeText)
        castingTime.attributedText = castingTimeBold
        
        let rangeBold = NSMutableAttributedString(string: "Range: ", attributes: attrs)
        let rangeText = NSMutableAttributedString(string: spell?.range ?? "")
        rangeBold.append(rangeText)
        range.attributedText = rangeBold
        
        // add components and include materials if applicable
       // components.text = "Components: " + (spell?.components)!
        let componentBold = NSMutableAttributedString(string: "Components: ", attributes: attrs)
        let componentText = NSMutableAttributedString(string: spell?.components ?? "")
        componentBold.append(componentText)
        if (spell?.material != nil) {
            componentBold.append(addMaterials())
        }
        components.attributedText = componentBold
        
        // add duration and concentration symbol if applicable
        //duration.text = "Duration: " + (spell?.duration)!
        let durationBold = NSMutableAttributedString(string: "Duration: ", attributes: attrs)
        let durationText = NSMutableAttributedString(string: spell?.duration ?? "")
        durationBold.append(durationText)
        if (spell?.concentration == "yes") {
            let concentrationSymbol = NSMutableAttributedString(string: "  \u{00A9}")
            durationBold.append(concentrationSymbol)
        }
        duration.attributedText = durationBold
        
        spellDescription.text = (spell?.desc)!
        if spell?.higherLevel != nil {
            //higherLevels.text = "Higher Level: " + (spell?.higherLevel)!
            let higherLevelBold = NSMutableAttributedString(string: "Higher Level: ", attributes: attrs)
            let higherLevelText = NSMutableAttributedString(string: spell?.higherLevel ?? "")
            higherLevelBold.append(higherLevelText)
            higherLevels.attributedText = higherLevelBold
        }
    }
    
    func addMaterials() -> NSMutableAttributedString {
        //let materialText = spell?.material
        let materialText = NSMutableAttributedString(string: " (" + spell!.material! + ")")
        return materialText
        

    }

}
