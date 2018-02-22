//
//  SpellsTableViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/15/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class SpellsTableViewController: UITableViewController {
    
    @IBOutlet weak var sortingChoice: UISegmentedControl!
    let jsonName = "spells"
    var spellsSortedLevel = [Spell]() {
        didSet {
            spells = spellsSortedLevel
        }
    }
    var spells = [Spell]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let spellJSON = readJson(with: jsonName) as? [Spell] {
            spellsSortedLevel = spellJSON
        }
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(spells.count)
        return spells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let spell = spells[indexPath.row]
        cell.textLabel?.text = spell.name
        cell.detailTextLabel?.text = spell.level

        return cell
    }
    
    // Mark: - Segment Control
    
    @IBAction func sortingChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            spells = spellsSortedLevel
        }
        else {
            spells = spells.sorted { $0.name < $1.name}
        }
    }
    

}
