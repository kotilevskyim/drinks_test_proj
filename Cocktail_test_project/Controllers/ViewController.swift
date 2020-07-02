//
//  ViewController.swift
//  Cocktail_test_project
//
//  Created by Максим Котилевский on 30.06.2020.
//  Copyright © 2020 Максим Котилевский. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var dataSource: [Category]?
    let cellSpacingHeight: CGFloat = 5
    let  activityIndicator = UIActivityIndicatorView(style: .large)
    // MARK: - Outlets
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.prefetchDataSource = self
        self.tableView.separatorColor = .clear
        setActivityIndicator()
        
        
        let imageView = UIImageView()
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 20)])
        let titleLabel = UILabel()
        titleLabel.text = "Drinks"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        let hStack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        //        spacing to the left
        hStack.spacing = -180
        //        hStack.alignment = .center
        navigationItem.titleView = hStack
        
        DataBaseService.getRandomCocktailList { (apiResponse) in
            if let response = apiResponse {
                let drinksItems = response.drinks.map { item in
                    return DrinkItem(name: item.strDrink , imageUrl: item.strDrinkThumb , id: item.idDrink)
                }
                let category = Category(name: "Ordinary Drink", drinks: drinksItems)
                self.dataSource = [category]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.isHidden = true
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.isHidden = false
        dataSource?.removeAll()
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFilter" {
            let filterVC = segue.destination as? FilterViewController
            filterVC?.delegate = self
        }
    }
}

// MARK: - Extension

extension ViewController: FilterDelegate {
    func filterDidFilterDrinks(drinks: [Drinks], filters: [String]) {
        guard drinks.count == filters.count else {
            fatalError("Arrays count are not equal.")
        }
        let combined = Array(zip(filters, drinks.map{$0.drinks}))
        print(combined)
        self.dataSource = combined.map({Category(name: $0.0, drinks: $0.1.map({DrinkItem(name: $0.strDrink, imageUrl: $0.strDrinkThumb, id: $0.idDrink)}))})
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate,  UITableViewDataSource {
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let dataSource = dataSource else {
            return 1
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let dataSource = dataSource else {
            return nil
        }
        return dataSource[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else {
            return 1
        }
        return dataSource[section].drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let dataSource = dataSource else {
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell else {return UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
            
        }
        cell.cocktailImg.image = UIImage(data: dataSource[indexPath.section].drinks[indexPath.row].image!)
        cell.cocktailLbl.text = dataSource[indexPath.section].drinks[indexPath.row].name
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = [dataSource].count - 1
        if indexPath.row == lastItem {
            
        }
    }
//    func moreData() {
//        for item in 1 ..< 10 {
//            print(moreData)
//            let lastItem = dataSource?.last
//            var newValue: [Category] = [lastItem!] + [1]
//            dataSource?.append(newElement: newValue)
//
//
////            dataSource?.append([dataSource] + Array[1])
//        }
//        tableView.reloadData()
//    }
    
    
    func setActivityIndicator() {
        activityIndicator.frame = CGRect(x: view.frame.width / 2 - 10, y: view.frame.height/2 - 10, width: 20, height: 20)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    
}
