//
//  SpellsTableViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/15/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class SpellsTableViewController: UITableViewController, SpellCellDelegate {
    
    @IBOutlet weak var sortingChoice: UISegmentedControl!
    
   // @IBOutlet weak var tabBar: UITabBarItem!
    var tabBar = UITabBarItem()
    
    
    
    // Setup initial spell list
    let jsonName = "spells"
    var spells = [Spell]() {
        didSet {
            tableView.reloadData()
        }
    }
    var filteredSpells = [Spell]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // Identifier to sort spells by class
    var character: Character! {
        didSet {
            // Update Model Controller whenever character is updated
            if let spellTabBarController = tabBarController as? SpellTabBarController {
                spellTabBarController.characterModel.characters[spellTabBarController.index] = character!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar = (tabBarController?.tabBar.selectedItem)!

        if let spellJSON = readJson(with: jsonName) as? [Spell] {
            // Load spells from JSON and sort by level by calling segment control
            spells = spellJSON
            sortByLevel()
        }
        
        // Set search bar parameters
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Spells"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // set navigation bar back button
        navigationItem.backBarButtonItem?.title = tabBar.title ?? "Spells"
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // reload character data in case something changed while changing between tabs
        if let tabBarController = tabBarController as? SpellTabBarController {
            let index = tabBarController.index!
            character = tabBarController.characterModel.characters[index]
        }
        
        // Check if this is a prepared list or all spells list
        if tabBar.title == "Class Spells" {
            spells = spells.filter( {(spell: Spell) -> Bool in
                    return spell.classes.contains(character!.spellList)
            })
        }
        else if (tabBar.title == "Prepared Spells") || (tabBar.title == "Known Spells") {
            spells = character!.preparedOrKnownSpells
        }
        else {
            spells = character!.wizardKnownSpells
        }
        sortByLevel()
        tableView.reloadData() 
    }
    
    
    // Mark: -  Search Controller Setup
    
    let searchController = UISearchController(searchResultsController: nil)
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredSpells = spells.filter( {(spell: Spell) -> Bool in
                return spell.name.lowercased().contains(searchText.lowercased())
            })
      //  tableView.reloadData() added to didset???
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    


    // MARK: - Table view data source/delegation
    
    let sections = ["Cantrip", "1st-level", "2nd-level", "3rd-level", "4th-level", "5th-level", "6th-level", "7th-level", "8th-level", "9th-level"]
    
    
    // Set title to nil if no spells in that list
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // Check to see if there are any spells in the list and make nil if not
        var emptySpell = true
        for spell in spells {
            if spell.level == sections[section] {
                emptySpell = false
            }
        }
        switch emptySpell {
        case true:
            return nil
        default:
            return sections[section]
        }
    }
    
    
    // Set view height to 0 if no spells in that list
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return 0
        }
        
        return 60
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if spells.count == 0 {
            
            // Set up background label if table is empty
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            if (tabBar.title == "Prepared Spells") {
                noDataLabel.text = "No Spells Prepared"
            }
            else {
                noDataLabel.text = "No Spells Known"
            }
            
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
            return 0
        }
        
        else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            return sections.count
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            let sectionedFilteredSpells = filteredSpells.filter({$0.level == sections[section]})
            return sectionedFilteredSpells.count
        }
        let sectionedSpells = spells.filter({$0.level == sections[section]})
        return sectionedSpells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> SpellTableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "spellCell", for: indexPath) as! SpellTableViewCell
        
        cell.delegate = self
        let spell: Spell
        if isFiltering() {
            spell = filteredSpells.filter({$0.level == sections[indexPath.section]})[indexPath.row]
            
        }
        else {
            spell = spells.filter({$0.level == sections[indexPath.section]})[indexPath.row]
        }
        cell.name.text = spell.name
        cell.level.text = spell.level
        
        // change button to "added" if spell is in prepared/known/wizardknown list
        if (character!.preparedOrKnownSpells.contains(where: {$0.name == cell.name.text})) || (character!.wizardKnownSpells.contains(where: {$0.name == cell.name.text})) {
            cell.addSpellButton?.setTitle("Added", for: .normal)
            
            // Check wizard's case, only show added in spellbook if it is also prepared
            if (tabBar.title == "Spellbook") && !(character!.preparedOrKnownSpells.contains(where: {$0.name == cell.name.text})) {
                cell.addSpellButton?.setTitle("+", for: .normal)
            }
        }
        else {
            cell.addSpellButton.setTitle("+", for: .normal)
        }
        
        // Don't show button in Prepared/Known Spells tab
        if (tabBar.title == "Prepared Spells") || (tabBar.title == "Known Spells") {
            cell.addSpellButton.isHidden = true
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (tabBar.title != "Class Spells")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) && (tabBar.title != "Class Spells") {
            
            if (tabBar.title == "Spellbook") {
                // remove from prepared spells first
                let spellName = character?.wizardKnownSpells[indexPath.row].name
                let filteredPreparedOrKnownSpells = character!.preparedOrKnownSpells.filter { $0.name == spellName }
                character!.preparedOrKnownSpells = filteredPreparedOrKnownSpells
                
                // Remove from wizard spellbook
                character!.wizardKnownSpells.remove(at: indexPath.row)
                spells = character!.wizardKnownSpells
            }
            
            else {
                // Remove from prepared or known spells
                character!.preparedOrKnownSpells.remove(at: indexPath.row)
                spells = character!.preparedOrKnownSpells
            }
            
            //Reload tableView
            tableView.reloadData()
        }
    }
    
    // Always sort spells by level
    func sortByLevel() {
        spells = spells.sorted {
            if ($0.level == "Cantrip" && $1.level != "Cantrip") {
                return true
            }
            else if ($0.level != "Cantrip" && $1.level == "Cantrip") {
                return false
            }
                
            else if ($0.level == $1.level) {
                return $0.name < $1.name
            }
            else {
                return $0.level < $1.level
            }
        }
    }
    
    // Mark: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "spellDetail" {
            if let spellDetailVC = segue.destination.content as? SpellDetailViewController {
                if let index = tableView.indexPathForSelectedRow {
                    spellDetailVC.spell = spells[index.row]
                }
            }
        }
    }
    
    @IBAction func returnToCharacters(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Mark: - Cell Protocol
    
    func spellButtonPressed(cell: SpellTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        let spell = spells.filter({$0.level == sections[(indexPath?.section)!]})[(indexPath?.row)!]
        
        // Check if wizard first and add accordingly
        if tabBarController?.viewControllers?.count == 3 {
            switch (tabBar.title)! {
            case "Class Spells":
                if !(character!.wizardKnownSpells.contains(where: {$0.name == spell.name})) {
                    character!.wizardKnownSpells.append(spell)
                }
            default:
                if !(character!.preparedOrKnownSpells.contains(where: {$0.name == spell.name})) {
                    character!.preparedOrKnownSpells.append(spell)
                }
            }
        }
        // if not wizard, do default saving
        else {
            if !(character!.preparedOrKnownSpells.contains(where: {$0.name == spell.name})) {
                character!.preparedOrKnownSpells.append(spell)
            }
        }
        tableView.reloadData()
    }

}

extension UIViewController {
    
    var content: UIViewController {
        if let navCon = self as? UINavigationController {
            return navCon.visibleViewController ?? self
        }
        else if let tabBar = self as? UITabBarController {
            if let navCon = tabBar.viewControllers?[0] as? UINavigationController {
                return navCon.visibleViewController ?? self
            }
            else {
                return self
            }
        }
        else {
            return self
        }
    }
}

// Delegation for search bar
extension SpellsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
