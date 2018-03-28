//
//  Character.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 3/3/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import Foundation

struct Character: Codable {
    let name: String
    var preparedOrKnownSpells: [Spell]
    var wizardKnownSpells: [Spell]
    var spellList: String
}

class CharacterModelController {

    var characters =  [Character]() {
        didSet {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(characters), forKey: "characters")
        }
    }
    
    init() {
        if let data = UserDefaults.standard.value(forKey: "characters") as? Data {
            characters = (try? PropertyListDecoder().decode(Array<Character>.self, from: data)) ?? [Character]()
          //  characters = characters2 ?? [Character]()
        }
    }


    
}
