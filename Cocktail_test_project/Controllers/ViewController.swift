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
    
    let  activityIndicator = UIActivityIndicatorView(style: .large)
    // MARK: - Outlets
    

    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.tableView.separatorColor = .clear
        
      

     setActivityIndicator()
//
//        let imageView = UIImageView()
//        NSLayoutConstraint.activate([
//            imageView.heightAnchor.constraint(equalToConstant: 20),
//            imageView.widthAnchor.constraint(equalToConstant: 20)
//        ])
//        imageView.backgroundColor = .red
//
//        let titleLabel = UILabel()
//        titleLabel.text = "Drinks"
//
//        let hStack = UIStackView(arrangedSubviews: [imageView, titleLabel])
//        hStack.spacing = 5
//        hStack.alignment = .center
//
//        navigationItem.titleView = hStack
        
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


}

// MARK: - Extension

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell
        cell?.cocktailImg.image = UIImage(data: dataSource[indexPath.section].drinks[indexPath.row].image!)
        cell?.cocktailLbl.text = dataSource[indexPath.section].drinks[indexPath.row].name

        return cell!
    }
    

      func setActivityIndicator() {
           activityIndicator.frame = CGRect(x: view.frame.width / 2 - 10, y: view.frame.height/2 - 10, width: 20, height: 20)
           activityIndicator.startAnimating()
           view.addSubview(activityIndicator)
        
       
    }
    
    
}
