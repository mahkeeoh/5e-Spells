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
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    var filterType: Int?
    var spellDetailsFilter:[[String: [String]]] = []
    var callback: (([[String: [String]]]) ->())?
    
    let filterValues = [
        ["Cantrip", "1st-level", "2nd-level", "3rd-level", "4th-level", "5th-level", "6th-level", "7th-level", "8th-level", "9th-level"],
        ["1 action", "1 bonus action", "1 reaction", "1 minute", "10 minutes", "1 hour", "8 hours", "12 hours", "24 hours"],
        ["Abjuration", "Conjuration", "Divination", "Enchantment", "Evocation", "Illusion", "Necromancy", "Transmutation"],
        ["Self", "Self (5-foot radius)", "Touch", "Sight", "5 feet", "10 feet", "15 feet", "30 feet", "60 feet", "90 feet", "100 feet", "120 feet", "150 feet", "300 feet", "500 feet", "1 mile", "500 miles", "Unlimited"],
        ["yes", "no"]
    ]
    
    let filterTypeConversion = [0: "level",
                                1: "castingTime",
                                2: "school",
                                3: "range",
                                4: "concentration"]

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
        cell.textLabel?.textColor = Constants.textColor
        cell.tintColor = Constants.buttonColor
        if (checkCurrentlyFiltered(cellText: cell.textLabel?.text ?? "")) {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    // Mark: - Add checks to all previously filterd values
    func checkCurrentlyFiltered(cellText: String) -> Bool {
        let category = filterTypeConversion[filterType!]
        let detailDictionary = spellDetailsFilter[filterType!]
        let detailArray = detailDictionary[category!]

      //  if let index = filterValues[filterType!].firstIndex(of: value) {
        if ((detailArray?.contains(cellText))!) {
            return true
        }
        return false
       // }

        
    }
    
    // MARK: - Setup for when filter is chosen
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) {

            let selectedDetail = cell.textLabel!.text
            let category = filterTypeConversion[filterType!]
            // Sort through array to get dictionary for specific category
            let detailDictionary = spellDetailsFilter[filterType!]
            // Then grab array from that dictionary
            var detailArray = detailDictionary[category!]
            // And check if the detail is contained
            if (detailArray?.contains(selectedDetail!))!
            {
                cell.accessoryType = .none
                //let arrayIndex = selectedIndexPaths[filterType!].firstIndex(of: indexPath)
                //selectedIndexPaths.remove(at: arrayIndex!)
                let arrayIndex = detailArray?.firstIndex(of: selectedDetail!)
                detailArray?.remove(at: arrayIndex!)
            }
            else
            {
                cell.accessoryType = .checkmark
                //selectedIndexPaths[filterType!].append(indexPath)
                detailArray?.append(selectedDetail!)
            }
            
            // Not the most efficient but push it all back up to spellDetailsFilter to send back
            spellDetailsFilter[filterType!][category!] = detailArray
            
            // anything else you wanna do every time a cell is tapped
        }
        // send info back to parent using closure
        callback?(spellDetailsFilter)
    }


}
