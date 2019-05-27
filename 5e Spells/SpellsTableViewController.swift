//
//  SpellsTableViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/15/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit
import StoreKit

class SpellsTableViewController: DesignOfTableViewController, SpellCellDelegate, UISearchBarDelegate {
    
    
    var tabBar = UITabBarItem()
    var textBox = UITextView()
    
    // Variables for filter parameters
    var spellDetailsFilter:[[String: [String]]] = []
    
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
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar = (tabBarController?.tabBar.selectedItem)!
        
        // Add header view to show if filter is active
        tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 0.0))
        
        loadSpells()
        
        // Set footer so blank cells don't show
        tableView.tableFooterView = UIView()
        
        // Set character icon button
        let characterButton = UIButton(type: .custom)
        characterButton.setImage(UIImage(named: "CharacterIcon"), for: .normal)
        characterButton.addTarget(self, action: #selector(returnToCharacters(_:)), for: .touchUpInside)
        characterButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        
        let leftBarButton = UIBarButtonItem(customView: characterButton)
        //assign button to navigationbar
        navigationItem.leftBarButtonItem = leftBarButton
        
        
        // Set search bar parameters
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Spells"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false // This should be fix to have search bar always appear
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        
        searchController.searchBar.tintColor = Constants.buttonColor
        
        
        let filterImage = UIImage(named: "FilterIcon")
        let filterImageView = UIImageView(image: filterImage)
        filterImageView.image = filterImageView.image?.withRenderingMode(.alwaysTemplate)
        filterImageView.tintColor = Constants.buttonColor
        searchController.searchBar.setImage(filterImageView.image, for: .bookmark, state: .normal)
       // searchController.searchBar.setImage(#imageLiteral(resourceName: "FilterIcon"), for: UISearchBarIcon.bookmark, state: UIControlState.normal)
        if let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textFieldInsideSearchBar.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        
        // Check rating request
        checkRatingRequest()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

        // reload character data in case something changed while changing between tabs
        if let tabBarController = tabBarController as? SpellTabBarController {
            let index = tabBarController.index!
            character = tabBarController.characterModel.characters[index]
        }
        
        // Check if this is a prepared list or all spells list
        if tabBar.title == ("Class Spells") || (tabBar.title == "All Spells") {
            loadSpells()
            sortByClass()
        }
        else if (tabBar.title == "Prepared Spells") || (tabBar.title == "Known Spells") {
            spells = character!.preparedOrKnownSpells
        }
        else {
            spells = character!.wizardKnownSpells
        }
        sortByLevel()
        
        spells = checkSpellFilters(spells)
        
    }
    
    // Check if it is time to request a rating
    func checkRatingRequest() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let cc = appDelegate.currentCount
        if (cc == 10) || (cc == 30) || (cc == 50) {
            if #available( iOS 10.3,*){
                SKStoreReviewController.requestReview()
                appDelegate.currentCount? += 1
            }
        }
    }

    // MARK: - Spell Preparation
    
    func loadSpells() {
        if let spellJSON = readJson(with: jsonName) as? [Spell] {
            // Load spells from JSON and sort by level by calling segment control
            spells = spellJSON
            
            sortByLevel()
            
        }
    }
    
    
    func sortByClass() {
        spells = spells.filter( {(spell: Spell) -> Bool in
            return spell.classes.contains(character!.spellList)
        })
        
        allSpellsButton.title = "All Spells"
        allSpellsButton.tintColor = Constants.navButtonColor
        
        title = "Class Spells"
    }
    
    // Setup filtering functionality (from filter choices as opposed to search bar)
    
    let filterTypes = ["level", "castingTime", "school", "range", "concentration"]
    
    func checkSpellFilters(_ spells: [Spell]) -> [Spell] {
        var newSpells = spells
        var count = 0
        // filter through dictionaries
        for filterType in spellDetailsFilter {
            for category in filterTypes {
                // if there are filters in that category
                if ((filterType[category]?.count != nil) && (filterType[category]?.count != 0)) {
                    count += 1
                    // Show view that alerts user a filter is in use
                   // tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20.0)
                    let filterDetails = filterType[category]
                    // grab those filters and filter the spells associated
                    var tempSpells: [Spell] = []
                    for detail in filterDetails! {
                        switch category {
                        case "level": tempSpells.append(contentsOf: newSpells.filter({$0.level == detail}))
                        case "castingTime":tempSpells.append(contentsOf: newSpells.filter({$0.castingTime == detail}))
                        case "school":tempSpells.append(contentsOf: newSpells.filter({$0.school ==  detail}))
                        case "range":tempSpells.append(contentsOf: newSpells.filter({$0.range == detail}))
                        case "concentration":tempSpells.append(contentsOf: newSpells.filter({$0.concentration == detail}))
                        default: continue
                        }
                    }
                    newSpells = tempSpells
                }
            }
        }
        // If no filters are in use, hide filter notification view
        
        let newTableViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 25.0))
        newTableViewHeader.backgroundColor = .gray
        textBox = UITextView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 25.0))
        textBox.text = "Filter Enabled"
        textBox.font = UIFont(name: Constants.font, size: 15)
        textBox.textColor = .white
        textBox.backgroundColor = .gray
        textBox.textAlignment = .center
        
        textBox.contentOffset.y = 4
        
        newTableViewHeader.addSubview(textBox)
        
        if count > 0 {
           /* tableView.tableHeaderView?.isHidden = false

            tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 25.0)
            tableView.tableHeaderView?.backgroundColor = .gray
            let textBox = UITextView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 25.0))
            textBox.text = "Filter Enabled"
            textBox.textColor = .white
            textBox.backgroundColor = .gray
            textBox.textAlignment = .center
            tableView.tableHeaderView?.addSubview(textBox)*/
            tableView.tableHeaderView = newTableViewHeader
        }
        else {
          //  tableView.tableHeaderView?.isHidden = true
            tableView.tableHeaderView = nil
        }
        return newSpells
    }
    
    // Setup "Clear Spells" button
    @IBOutlet weak var clearSpellsButton: UIBarButtonItem!
    @IBAction func clearSpellsButtonClicked(_ sender: UIBarButtonItem) {
        
        var alert: UIAlertController
        if (tabBar.title == "Prepared Spells") {
            alert = UIAlertController(title: "Clear all prepared spells?", message: "Are you sure you want to clear all of your prepared spells?", preferredStyle: .alert)
        }
        else {
            alert = UIAlertController(title: "Clear all known spells?", message: "Are you sure you want to clear all of your known spells?", preferredStyle: .alert)
        }
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.character.preparedOrKnownSpells.removeAll()
            self.spells = self.character!.preparedOrKnownSpells
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            return
        }))
        
        present(alert, animated: true)
    }
    
    
    // Setup "All Spells" button which allows user to view all spells in the book (for specific purposes)
    @IBOutlet weak var allSpellsButton: UIBarButtonItem!
    @IBAction func allSpellsButtonClicked(_ sender: UIButton) {
        
        // If all spells button clicked, change text and color to indicate
        if allSpellsButton.title == "All Spells" {
            allSpellsButton.title = "Class Spells"
            allSpellsButton.tintColor = UIColor.red
            
            // Change title to clarify
            title = "All Spells"
            
            // And load all spells
            loadSpells()
            
        }
        // Or revert back to normal text/color
        else {
            sortByClass()
        }
        
        spells =  checkSpellFilters(spells)
        
        // animate tableview appearing
        let trans = CATransform3DMakeTranslation(-tableView.frame.size.width, 0.0, 0.0)
        tableView.layer.transform = trans
        
        UIView.beginAnimations("Move", context: nil)
        UIView.setAnimationDuration(0.3)
        // UIView.setAnimationDelay(0.1 * Double(indexPath.row))
        tableView.layer.transform = CATransform3DIdentity
        UIView.commitAnimations()
        
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
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // Segue to filterVC if filter (bookmark) bar is pressed
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        self.performSegue(withIdentifier: "filterVC", sender: self)
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
    

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundView?.backgroundColor = Constants.headerColor
    }
    
    // Set view height to 0 if no spells in that list
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return 0
        }
        return 40
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if spells.count == 0 {
            
            // Set up background label if table is empty
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.lineBreakMode = .byWordWrapping
            noDataLabel.numberOfLines = 0
            noDataLabel.textColor = Constants.textColor
            if ((tabBar.title == "Prepared Spells") && (character.characterClass == "Wizard")) {
                noDataLabel.text = "No Spells Prepared, add some from the Spellbook tab below!"
            }
            else if (tabBar.title == "Prepared Spells") {
                noDataLabel.text = "No Spells Prepared, add some from the Class Spells tab below!"
            }
            else {
                noDataLabel.text = "No Spells Known, add some from the Class Spells tab below!"
            }

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
        cell.nameLabel.text = spell.name
        cell.nameLabel.textColor = Constants.textColor
        cell.actionTypeLabel.text = spell.castingTime
        cell.actionTypeLabel.textColor = Constants.textColor
        cell.rangeLabel.text = spell.range
        cell.rangeLabel.textColor = Constants.textColor
        if (spell.concentration == "yes") {
            //cell.actionTypeLabel.text = cell.actionTypeLabel.text! + "  \u{00A9}"
            let image = UIImage(named: "ConcentrationImage")
            let renderedImage = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.concentrationImage.image = renderedImage
            cell.concentrationImage.tintColor = Constants.buttonColor
           // cell.concentrationImage.image.im
        }
        cell.schoolImage.image = UIImage(named: spell.school)

        
        // change button to checkmark if spell is in prepared/known/wizardknown list
        if (character!.preparedOrKnownSpells.contains(where: {$0.name == cell.nameLabel.text})) || (character!.wizardKnownSpells.contains(where: {$0.name == cell.nameLabel.text})) {
            let image = UIImage(named: "CheckButton")
            let renderedImage = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.addSpellButton.setImage(renderedImage, for: .normal)
            cell.addSpellButton.tintColor = Constants.buttonColor
            
            // Check wizard's case, only show added in spellbook if it is also prepared
            if (tabBar.title == "Spellbook") && !(character!.preparedOrKnownSpells.contains(where: {$0.name == cell.nameLabel.text})) {
                let image = UIImage(named: "PlusButton")
                let renderedImage = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                cell.addSpellButton.setImage(renderedImage, for: .normal)
                cell.addSpellButton.tintColor = .gray
            }
        }
        else {
            let image = UIImage(named: "PlusButton")
            let renderedImage = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.addSpellButton.setImage(renderedImage, for: .normal)
            cell.addSpellButton.tintColor = .gray
        }
        
        // Don't show button in Prepared/Known Spells tab
        if (tabBar.title == "Prepared Spells") || (tabBar.title == "Known Spells") {
            cell.addSpellButton.isHidden = true
        }
        
        //cell.addSpellButton.tintColor = Constants.buttonColor
        cell.addSpellButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)

        return cell
    }
    
    
    // only edit spells outside of class list
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !((tabBar.title == "Class Spells") || tabBar.title == "All Spells")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) && !((tabBar.title == "Class Spells") || tabBar.title == "All Spells") {
            
            // First find name of spell (depending on if currently filtering or not)
            var spellName: String?
            if isFiltering() {
                spellName = filteredSpells.filter({$0.level == sections[indexPath.section]})[indexPath.row].name
                
            }
            else {
                spellName = spells.filter({$0.level == sections[indexPath.section]})[indexPath.row].name
            }
            
            // Filter spells so
            let filteredPreparedOrKnownSpells = character!.preparedOrKnownSpells.filter { $0.name != spellName }
            
            // Take care of wizard's spellbook, then delete in prepared as well
            if (tabBar.title == "Spellbook") {

                character!.preparedOrKnownSpells = filteredPreparedOrKnownSpells
                
                // Remove from wizard spellbook
                let filteredWizardSpells = character!.wizardKnownSpells.filter { $0.name != spellName }
                character!.wizardKnownSpells = filteredWizardSpells
                spells = character!.wizardKnownSpells
                sortByLevel()
            }
            
            else {
                // Else just remove from prepared or known spells
                character!.preparedOrKnownSpells = filteredPreparedOrKnownSpells
                spells = character!.preparedOrKnownSpells
                sortByLevel()
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
    
    // Add subclass features for each class
    func listSubclassSpells(_ spell: Spell) -> String! {
        var levelText = spell.level
        switch character.characterClass {
        case "Cleric":
            switch spell.archetype {
            case "Cleric: Knowledge"?:
                levelText += " (Knowledge Domain Only)"
            case "Cleric: Life"?:
                levelText += " (Life Domain Only)"
            case "Cleric: Light"?:
                levelText += " (Light Domain Only)"
            case "Cleric: Nature"?:
                levelText += " (Nature Domain Only)"
            case "Cleric: Tempest"?:
                levelText += " (Tempest Domain Only)"
            case "Cleric: Trickery"?:
                levelText += " (Trickery Domain Only)"
            case "Cleric: War"?:
                levelText += " (War Domain Only)"
            default:
                return levelText
            }
        case "Paladin":
            switch spell.archetype {
            case "Paladin: Devotion"?:
                levelText += " (Devotion Oath Only)"
            case "Paladin: Ancients"?:
                levelText += " (Ancients Oath Only)"
            case "Paladin: Vengeance"?:
                levelText += " (Vengeance Oath Only)"
            default:
                return levelText
            }
        case "Druid":
            switch spell.archetype {
            case "Druid: Arctic"?:
                levelText += " (Arctic Circle Only)"
            case "Druid: Coast"?:
                levelText += " (Coast Circle Only)"
            case "Druid: Desert"?:
                levelText += " (Desert Circle Only)"
            case "Druid: Forest"?:
                levelText += " (Forest Circle Only)"
            case "Druid: Grassland"?:
                levelText += " (Grassland Circle Only)"
            case "Druid: Mountain"?:
                levelText += " (Mountain Circle Only)"
            case "Druid: Swamp"?:
                levelText += " (Swamp Circle Only)"
            case "Druid: Underdark"?:
                levelText += " (Underdark Circle Only)"
            default:
                return levelText
            }
        case "Warlock":
            switch spell.archetype {
            case "Warlock: Archfey"?:
                levelText += " (Archfey Patron Only)"
            case "Warlock: Fiend"?:
                levelText += " (Fiend Patron Only)"
            case "Warlock: Great Old One"?:
                levelText += " (Great Old One Patron Only)"
            default:
                return levelText
            }
            
        
        default:
            return levelText
        }
        return levelText
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "spellDetail" {
            if let spellDetailVC = segue.destination.content as? SpellDetailViewController {
                if let index = tableView.indexPathForSelectedRow {
                    var spell: Spell?
                    
                    // Again, choose index depending on if filtered or not
                    if isFiltering() {
                        spell = filteredSpells.filter({$0.level == sections[index.section]})[index.row]
                        
                    }
                    else {
                        spell = spells.filter({$0.level == sections[index.section]})[index.row]
                    }
                    spellDetailVC.spell = spell!
                }
            }
        }
        else if segue.identifier == "filterVC" {
            if let filterVC = segue.destination.content as? FilterTableViewController {
                filterVC.spellDetailsFilter = spellDetailsFilter
                filterVC.callback = { [unowned self] result in
                    self.spellDetailsFilter = result
                }
            }
        }
    }
    
    @IBAction func returnToCharacters(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Mark: - Cell Protocol
    
    func spellButtonPressed(cell: SpellTableViewCell) {
        
        // Provide haptic feedback when added/removed
        let selection = UIImpactFeedbackGenerator()
        selection.impactOccurred()
        
        // Determine which spell is being selected
        let indexPath = tableView.indexPath(for: cell)
        let spell = spells.filter({$0.level == sections[(indexPath?.section)!]})[(indexPath?.row)!]
        
        // Check if wizard first and add accordingly
        if tabBarController?.viewControllers?.count == 3 {
            switch (tabBar.title)! {
            case "Class Spells", "All Spells":
                // Add to wizard list if clicking add button from class list
                if !(character!.wizardKnownSpells.contains(where: {$0.name == spell.name})) {
                    character!.wizardKnownSpells.append(spell)
                    
                    // Check if spell is cantrip and add to prepared as well if so
                    if (spell.level == "Cantrip") {
                        character!.preparedOrKnownSpells.append(spell)
                    }
                }
                // Else remove from both prepared and wizard list if removed from here
                else {
                    let removedWizardSpellList = character!.wizardKnownSpells.filter{$0.name != spell.name}
                    character!.wizardKnownSpells = removedWizardSpellList
                    
                    let removedPreparedSpellList = character!.preparedOrKnownSpells.filter{$0.name != spell.name}
                    character!.preparedOrKnownSpells = removedPreparedSpellList
                }
            default:
                // Add to wizard prepared list if clicking add button from wizard known list
                if !(character!.preparedOrKnownSpells.contains(where: {$0.name == spell.name})) {
                    character!.preparedOrKnownSpells.append(spell)
                }
                // else remove just from prepared list
                else {
                    let removedPreparedSpellList = character!.preparedOrKnownSpells.filter{$0.name != spell.name}
                    character!.preparedOrKnownSpells = removedPreparedSpellList
                }
            }
        }
        // if not wizard, do default saving
        else {
            // Save spell if it doesn't already exist in prepared/known lists
            if !(character!.preparedOrKnownSpells.contains(where: {$0.name == spell.name})) {
                character!.preparedOrKnownSpells.append(spell)
            }
            // Else remove the spell if clicked again
            else {
                let removedPreparedSpellList = character!.preparedOrKnownSpells.filter {$0.name != spell.name}
                character!.preparedOrKnownSpells = removedPreparedSpellList
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
