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
    var tabBar: UITabBarItem?
    
    
    
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
    var character: Character? {
        didSet {
            // Update Model Controller whenever character is updated
            if let spellTabBarController = tabBarController as? SpellTabBarController {
                spellTabBarController.characterModel.characters[spellTabBarController.index] = character!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar = tabBarController?.tabBar.selectedItem

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
        navigationItem.backBarButtonItem?.title = tabBar?.title ?? "Spells"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Check if this is a prepared list or all spells list
        if tabBar?.title == "Class Spells" {
            spells = spells.filter( {(spell: Spell) -> Bool in
                    return spell.classes.contains(character!.name)
            })
        }
        else if (tabBar?.title == "Prepared Spells") || (tabBar?.title == "Known Spells") {
            
            spells = character!.preparedOrKnownSpells
        }
        else {
            spells = character!.wizardKnownSpells
        }

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

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if spells.count == 0 {
            
            // Set up background label if table is empty
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            if (tabBar?.title == "Prepared Spells") {
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
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() { return filteredSpells.count}
        return spells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> SpellTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SpellTableViewCell
        cell.delegate = self
        let spell: Spell
        if isFiltering() { spell = filteredSpells[indexPath.row]} else {spell = spells[indexPath.row]}
        cell.name.text = spell.name
        cell.level.text = spell.level
        
        
        if (tabBar?.title == "Prepared Spells") || (tabBar?.title == "Known Spells") {
            cell.addSpellButton.isHidden = true
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) && (tabBar?.title != "Class Spells") {
            
            if (tabBar?.title == "Spellbook") {
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
    
    // Mark: - Segment Control (level vs name)
    
    @IBAction func sortingChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sortByLevel()
        }
            
        else {
            spells = spells.sorted { $0.name < $1.name}
        }
    }
    
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
        let spell = spells[(indexPath?.row)!]
        
        // Check if wizard first and add accordingly
        if tabBarController?.viewControllers?.count == 3 {
            switch (tabBar?.title)! {
            case "Class Spells":
                if let spellbookNavigationVC = tabBarController?.viewControllers![1] as? UINavigationController {
                    if let spellbookVC = spellbookNavigationVC.visibleViewController as? SpellsTableViewController {
                        if !(spellbookVC.character!.wizardKnownSpells.contains(where: {$0.name == spell.name})) {
                            // Check this to make sure nil value doesn't allow it to pass
                            spellbookVC.character!.wizardKnownSpells.append(spell)
                        }
                    }
                }
            default:
                if let preparedSpellsNavigationVC = tabBarController?.viewControllers![0] as? UINavigationController {
                    if let preparedSpellsVC = preparedSpellsNavigationVC.visibleViewController as? SpellsTableViewController {
                        
                        if !(preparedSpellsVC.character!.preparedOrKnownSpells.contains(where: {$0.name == spell.name})) {
                            // Check this to make sure nil value doesn't allow it to pass
                            preparedSpellsVC.character!.preparedOrKnownSpells.append(spell)
                        }
                    }
                }
            }
        }
        // if not wizard, do default saving
        else {
            if let preparedSpellsNavigationVC = tabBarController?.viewControllers![0] as? UINavigationController {
                if let preparedSpellsVC = preparedSpellsNavigationVC.visibleViewController as? SpellsTableViewController {

                    if !(preparedSpellsVC.character!.preparedOrKnownSpells.contains(where: {$0.name == spell.name})) {
                        // Check this to make sure nil value doesn't allow it to pass
                        preparedSpellsVC.character!.preparedOrKnownSpells.append(spell)
                    }
                }
            }
        }
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
