//
//  SpellDetailViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/22/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class SpellDetailViewController: UIViewController {
    
    @IBOutlet weak var levelTextView: UITextView!
    @IBOutlet weak var schoolTextView: UITextView!
    @IBOutlet weak var timeTextView: UITextView!
    @IBOutlet weak var rangeTextView: UITextView!
    @IBOutlet weak var componentsTextView: UITextView!
    @IBOutlet weak var durationTextView: UITextView!
    @IBOutlet weak var classesTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
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
        levelTextView.text = "LEVEL: \n" + (spell?.level)!
        schoolTextView.text = "SCHOOL: \n" + (spell?.school)!
        timeTextView.text = "CASTING TIME: \n" + (spell?.castingTime)!
        rangeTextView.text = "RANGE: \n" + (spell?.range)!
        componentsTextView.text = "COMPONENTS: \n" + (spell?.components)!
        durationTextView.text = "DURATION: \n" + (spell?.duration)!
        classesTextView.text = "CLASSES: \n" + (spell?.classes)!
        descriptionTextView.text = "DESCRIPTION: \n" + (spell?.desc.replacingOccurrences(of: "<p>", with: "\n"))!
    }

}
