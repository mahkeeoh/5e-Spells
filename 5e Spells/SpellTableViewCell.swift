//
//  SpellTableViewCell.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/28/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class SpellTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var actionTypeLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var addSpellButton: UIButton!
    @IBOutlet weak var schoolImage: UIImageView!
 
    @IBAction func spellButtonPressed(_ sender: Any) {
        delegate?.spellButtonPressed(cell: self)
    }
    
    
    var delegate: SpellCellDelegate?

    
}

protocol SpellCellDelegate {
    func spellButtonPressed(cell: SpellTableViewCell)
}
