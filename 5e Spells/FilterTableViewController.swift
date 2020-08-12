//
//  FilterTableViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 7/7/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class FilterTableViewController: DesignOfTableViewController {
    
    // Add connection to cells to set color
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var castingLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var concentrationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        setFilterTypes()
        levelLabel.textColor = Constants.textColor
        castingLabel.textColor = Constants.textColor
        schoolLabel.textColor = Constants.textColor
        rangeLabel.textColor = Constants.textColor
        concentrationLabel.textColor = Constants.textColor
        navigationController?.navigationBar.tintColor = Constants.navButtonColor
        
        // Add Reset button
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetFilters))
        navigationItem.rightBarButtonItem = resetButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for cellCount in 0...4 {
            let indexPath = IndexPath(row: cellCount, section: 0)
            let filterDetail = spellDetailsFilter[cellCount]
            let filterName = filterTypeConversion[cellCount]
            let sortingArray = filterValues[cellCount]
            var text = ""
            for filters in filterDetail {
                if (filters.key == filterName) {
                    let values = filters.value
                    let sortedValues = sortingArray.filter {values.contains($0)}
                    text = text + sortedValues.joined(separator: ", ")
                }
            }
            tableView.cellForRow(at: indexPath)?.detailTextLabel!.text = text
            tableView.cellForRow(at: indexPath)?.detailTextLabel!.textColor = Constants.textColor
            tableView.reloadData()
        }
    }
    
    let filterTypeConversion = [0: "level",
                                1: "castingTime",
                                2: "school",
                                3: "range",
                                4: "concentration"]
    
    let filterValues = [
        ["Cantrip", "1st-level", "2nd-level", "3rd-level", "4th-level", "5th-level", "6th-level", "7th-level", "8th-level", "9th-level"],
        ["1 action", "1 bonus action", "1 reaction", "1 minute", "10 minutes", "1 hour", "8 hours", "12 hours", "24 hours"],
        ["Abjuration", "Conjuration", "Divination", "Enchantment", "Evocation", "Illusion", "Necromancy", "Transmutation"],
        ["Self", "Self (5-foot radius)", "Touch", "Sight", "5 feet", "10 feet", "15 feet", "30 feet", "60 feet", "90 feet", "100 feet", "120 feet", "150 feet", "300 feet", "500 feet", "1 mile", "500 miles", "Unlimited"],
        ["yes", "no"]
    ]
    

    let filterNames = ["Level", "Casting Time", "School", "Range", "Concentration"]
    var spellDetailsFilter:[[String: [String]]] = [] {
        didSet {
            callback?(spellDetailsFilter)
        }
    }
    
    var callback: (([[String: [String]]]) ->())?
    
    func setFilterTypes() {
        // Add all keys to dictionary (will want them added even if never used)
        for var filterName in filterNames {
            filterName = filterName.lowercased()
            if (filterName == "casting time") {
                filterName = "castingTime"
            }
            spellDetailsFilter.append([filterName: []])
        }
    }
    
    // Reset filter function
    @objc func resetFilters() {
        spellDetailsFilter = []
        setFilterTypes()
        navigationController?.popViewController(animated: true)
    }
    
    // Navigation to detail view

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "filterDetailVC", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let filterDetailVC = segue.destination.content as? FilterDetailTableViewController {
            if let cellIndex = tableView.indexPathForSelectedRow {
                filterDetailVC.title = filterNames[cellIndex.row]
                filterDetailVC.filterType = cellIndex.row
                filterDetailVC.spellDetailsFilter = spellDetailsFilter
                filterDetailVC.callback = { [unowned self] result in
                    self.spellDetailsFilter = result
                }
            }
            
        }
    }

}
