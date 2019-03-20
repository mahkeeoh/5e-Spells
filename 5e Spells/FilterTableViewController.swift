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
