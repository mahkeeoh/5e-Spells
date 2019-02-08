//
//  FilterTableViewController.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 7/7/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class FilterTableViewController: DesignOfTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFilterTypes()
        
        // Add Reset button
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetFilters))
        navigationItem.rightBarButtonItem = resetButton
    }
    

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
