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
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(characterModel.characters.description)
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
        
        return characterModel.characters.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "character", for: indexPath)

        let character = characterModel.characters[indexPath.row]
        cell.textLabel?.text = character.name

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
    
    // Unwind controller froma addCharacterVC
    @IBAction func addCharacterToVC(segue: UIStoryboardSegue) {
        if let addCharacterVC = segue.source as? AddCharacterViewController {
            let newCharacter = Character(name: addCharacterVC.characterChoice!, preparedSpells: [Spell]())
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
                    switch characterModel.characters[indexPath.row].name {
                    case "Bard", "Ranger", "Sorcerer", "Warlock":
                        firstTabBarTitle = "Known Spells"
                    
                    case "Cleric", "Druid", "Paladin":
                        firstTabBarTitle = "Prepared Spells"
                        
                    default:
                        firstTabBarTitle = "Not ready yet"
                    }
                    
                    
                    destinationVC.classTabName = firstTabBarTitle
                }
            }
        }
    }

}

