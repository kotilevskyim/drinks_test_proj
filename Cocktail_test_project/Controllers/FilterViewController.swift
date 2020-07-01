//
//  FilterViewController.swift
//  Cocktail_test_project
//
//  Created by Максим Котилевский on 01.07.2020.
//  Copyright © 2020 Максим Котилевский. All rights reserved.
//

import UIKit

protocol FilterDelegate: class {
    func filterDidFilterDrinks(drinks: [Drinks], filters: [String])
}

class FilterViewController: UIViewController {
    
    
    var dataSource: DrinkFilters?
    var dataFilter = [String]()
    weak var delegate: FilterDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = .clear
        
        let imageView = UIImageView()
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        
        let titleLabel = UILabel()
        titleLabel.text = "Filters"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        let hStack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        //        spacing to the left
        hStack.spacing = -150
        //        hStack.alignment = .center
        
        navigationItem.titleView = hStack
        
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
    
    @IBAction func applyButton(_ sender: Any) {
        // dataBaseService returns response
        self.navigationController?.popViewController(animated: true)
        DataBaseService.getFiteredDrinks(filters: dataFilter) { (result) in
            guard let result = result else { return }
            print("Got results =", result.count)
            self.delegate?.filterDidFilterDrinks(drinks: result, filters: self.dataFilter)
        }
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell" , for: indexPath)
        cell.textLabel?.text = dataSource?.drinks[indexPath.row].strCategory
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let dataSource = dataSource else {
            return 0
        }
        return dataSource.drinks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            dataFilter.remove(at: indexPath.row)
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            dataFilter.append(dataSource!.drinks[indexPath.row].strCategory)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}
