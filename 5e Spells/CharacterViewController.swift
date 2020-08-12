//
//  CharacterTableViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/27/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CharacterViewController: DesignOfViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    
    
    var characterModel: CharacterModelController!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 90.0
        addButton.tintColor = Constants.buttonColor
        bannerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Configuring Advertisements
        if !(SpellProducts.store.isProductPurchased(SpellProducts.SwiftShopping)) {
            bannerView.adUnitID = "ca-app-pub-6718527310816875/2490473069"
           // bannerView.adUnitID =  "ca-app-pub-3940256099942544/2934735716" TEST AD
            bannerView.rootViewController = self
            bannerView.backgroundColor = .clear
            bannerView.load(GADRequest())
            bannerView.adSize = kGADAdSizeSmartBannerPortrait
        }
        else {
            bannerView?.removeFromSuperview()
        }

    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        
        if characterModel.characters.count == 0 {
            
            // Set up background label if table is empty
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "Add a character with the + button below"
            noDataLabel.textColor = Constants.textColor
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // retrieve number of characters
        return characterModel.characters.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "character", for: indexPath) as! CharacterTableViewCell

        let character = characterModel.characters[indexPath.row]
      //  cell.textLabel?.text = character.characterName
        cell.characterName.text = character.characterName
        cell.characterName.textColor = Constants.textColor
        cell.characterClass.text = character.characterClass
        cell.characterClass.textColor = Constants.textColor
        
        
      //  cell.characterImage.image = UIImage(named: character.imageString)
        let image = UIImage(named: character.imageString)
        //let image = UIImage(named: "ConcentrationImage")
        cell.characterImage.image = image
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            // Remove from characters
            characterModel.characters.remove(at: indexPath.row)
            
            //Reload tableView
            tableView.reloadData()
        }
    }
    
    // need this to deselect cell for whatever reason
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
 
    
    // Mark: - Navigation
    
    // Unwind controller from addCharacterVC
    @IBAction func addCharacterToVC(segue: UIStoryboardSegue) {
        if let addCharacterVC = segue.source as? AddCharacterViewController {
            addCharacterVC.nameTextField.resignFirstResponder()
            // retrieve character spell list
            var spellList = addCharacterVC.characterClass!
            if (addCharacterVC.characterClass! == "Fighter") || (addCharacterVC.characterClass! == "Rogue") {
                spellList = "Wizard"
            }
            // add new character to characterModel
            let newCharacter = Character(characterClass: addCharacterVC.characterClass!, characterName: addCharacterVC.nameTextField.text!, preparedOrKnownSpells: [Spell](), wizardKnownSpells: [Spell](), spellList: spellList, imageString: addCharacterVC.characterImageString ?? "")
            characterModel.characters.append(newCharacter)
            tableView.reloadData()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "addCharacterSegue" {
            // Provide haptic feedback when added/removed
            let selection = UIImpactFeedbackGenerator()
            selection.impactOccurred()
            //if characterModel.characters.count == 0 {
            //    return true
           // }
            if (SpellProducts.store.isProductPurchased(SpellProducts.SwiftShopping)) || (characterModel.characters.count == 0) {
                return true
            }
            else {
                performSegue(withIdentifier: "payPremiumSegue", sender: self)
                return false
            }
        }
        return true
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

