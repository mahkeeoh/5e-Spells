//
//  SpellTableViewCell.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/28/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class SpellTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var addSpellButton: UIButton!
    
    @IBAction func spellButtonPressed(_ sender: UIButton) {
        delegate?.spellButtonPressed(cell: self)
    }
    
    var delegate: SpellCellDelegate?
    
}

protocol SpellCellDelegate {
    func spellButtonPressed(cell: SpellTableViewCell)
}
