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
    }

    let filterNames = ["Level", "Casting Time", "School", "Range", "Concentration"]
    
    
    
    // Navigation to detail view

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "filterDetailVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let filterDetailVC = segue.destination.content as? FilterDetailTableViewController {
            if let cellIndex = tableView.indexPathForSelectedRow {
                filterDetailVC.title = filterNames[cellIndex.row]
                filterDetailVC.filterType = cellIndex.row
            }
            
        }
    }

}
