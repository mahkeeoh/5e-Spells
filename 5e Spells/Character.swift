//
//  Character.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 3/3/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import Foundation

struct Character {
    let name: String
    var preparedSpells: [Spell]
}

class CharacterModelController {

    var characters = UserDefaults.standard.object(forKey: "Characters") as? [Character] ?? [Character]() {
        didSet {
            UserDefaults.standard.set(characters, forKey: "Characters")
        }
    }
    
    // Delete all above and do:
    var characters = [Character]()
    
    // Add NSCoding protocol to CharacterModelController
    
     func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(characters, forKey: "characters")
     }
    
     required init(coder aDecoder: NSCoder) {
        super.init()
        characters = aDecoder.decodeObjectForKey("characters") as! [Character]
    }
    
    
}
