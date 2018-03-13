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
    var preparedOrKnownSpells: [Spell]
    var wizardKnownSpells: [Spell]
    var spellList: String
}

class CharacterModelController {

    var characters = [Character]()
    
}
