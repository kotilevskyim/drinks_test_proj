//
//  FilterTableViewController.swift
//  Cocktail_test_project
//
//  Created by Максим Котилевский on 01.07.2020.
//  Copyright © 2020 Максим Котилевский. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {
    
    var dataSource: DrinkFilters?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = .clear

        DataBaseService.getFilters { (filters) in
            guard let unwrappedFilters = filters else { return }
            self.dataSource = unwrappedFilters
            DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        }
      
    }
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let dataSource = dataSource else {
            return 0
        }
        return dataSource.drinks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        cell.textLabel?.text = dataSource?.drinks[indexPath.row].strCategory

        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
 
    


}
