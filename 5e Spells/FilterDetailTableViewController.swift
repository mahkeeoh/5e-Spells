//
//  FilterDetailTableViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 7/8/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class FilterDetailTableViewController: DesignOfTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var filterType: Int?
    
    let filterValues = [
        ["Cantrip", "First-level", "Second-level", "Third-level", "Fourth-level", "Fifth-level", "Sixth-level", "Seventh-level", "Eighth-level", "Ninth-level"],
        ["1 action", "1 bonus action", "1 reaction", "1 minute", "10 minutes", "1 hour", "8 hours", "12 hours", "24 hours"],
        ["Abjuration", "Conjuration", "Divination", "Enchantment", "Evocation", "Illusion", "Necromancy", "Transmutation"],
        ["Self", "Self (5-foot radius)", "Touch", "Sight", "5 feet", "10 feet", "15 feet", "30 feet", "60 feet", "90 feet", "100 feet", "120 feet", "150 feet", "300 feet", "500 feet", "1 mile", "500 miles", "Unlimited"],
        ["yes", "no"]
    ]

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filterValues[filterType!].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterDetailCell", for: indexPath)

        cell.textLabel?.text = filterValues[filterType!][indexPath.row]

        return cell
    }
    


}
