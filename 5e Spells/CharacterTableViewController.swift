//
//  CharacterTableViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/27/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class CharacterTableViewController: UITableViewController {
    
    var characterModel: CharacterModelController!

    override func viewDidLoad() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 90.0
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if characterModel.characters.count == 0 {
            
            // Set up background label if table is empty
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "Add a character with the + button above"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
            return 0
        }
            
        else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // retrieve number of characters
        return characterModel.characters.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "character", for: indexPath)

        let character = characterModel.characters[indexPath.row]
        cell.textLabel?.text = character.characterName
        cell.detailTextLabel?.text = character.characterClass

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            // Remove from characters
            characterModel.characters.remove(at: indexPath.row)
            
            //Reload tableView
            tableView.reloadData()
        }
    }
 
    // Mark: - Navigation
    
    // Unwind controller from addCharacterVC
    @IBAction func addCharacterToVC(segue: UIStoryboardSegue) {
        if let addCharacterVC = segue.source as? AddCharacterViewController {
            var spellList = addCharacterVC.characterClass!
            if (addCharacterVC.characterClass! == "Fighter") || (addCharacterVC.characterClass! == "Rogue") {
                spellList = "Wizard"
            }
            //let newCharacter = Character(name: addCharacterVC.characterClass!, preparedOrKnownSpells: [Spell](), wizardKnownSpells: [Spell](), spellList: spellList)
            let newCharacter = Character(characterClass: addCharacterVC.characterClass!, characterName: addCharacterVC.nameTextField.text!, preparedOrKnownSpells: [Spell](), wizardKnownSpells: [Spell](), spellList: spellList)
            characterModel.characters.append(newCharacter)
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSpells" {
            if let destinationVC = segue.destination as? SpellTabBarController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    // Add index for character selection and pass model to tab bar
                    destinationVC.index = indexPath.row
                    destinationVC.characterModel = characterModel
                    
                    // Set title of tab based on class
                    var firstTabBarTitle = ""
                    switch characterModel.characters[indexPath.row].characterClass {
                    case "Bard", "Ranger", "Sorcerer", "Warlock", "Fighter", "Rogue":
                        firstTabBarTitle = "Known Spells"
                    
                    case "Cleric", "Druid", "Paladin":
                        firstTabBarTitle = "Prepared Spells"
                      
                    // wizard has a special setup
                    default:
                        firstTabBarTitle = "Prepared Spells"
                        destinationVC.isWizard = true
                    }
                    
                    
                    destinationVC.classTabName = firstTabBarTitle
                }
            }
        }
    }

}

