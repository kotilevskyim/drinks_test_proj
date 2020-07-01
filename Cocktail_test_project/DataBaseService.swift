//
//  DataBaseService.swift
//  Cocktail_test_project
//
//  Created by Максим Котилевский on 30.06.2020.
//  Copyright © 2020 Максим Котилевский. All rights reserved.
//

import Foundation
import UIKit

struct DataBaseService {
    static let url = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c="
    static let urlForFilters = "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list"
    
    static func getRandomCocktailList(completion: @escaping((Drinks?) -> Void)) {
        guard let randomDrinks = URL(string: "\(url)Ordinary_Drink") else {return}
        
        let dataTask = URLSession.shared.dataTask(with: randomDrinks) { (data,_,_) in
            if let response = data {
                print(response)
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Drinks.self, from: response)
                    print(result)
                    completion(result)
                } catch {
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
            
        }
        dataTask.resume()
    }
    static func getFilters(completion: @escaping((DrinkFilters?) -> Void)){
        guard let urlFilter = URL(string: urlForFilters) else {return}
        let dataTask = URLSession.shared.dataTask(with: urlFilter) { (data,_,_) in
            if let response = data {
                print(response)
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(DrinkFilters.self, from: response)
                    completion(result)
                } catch {
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
            
        }
        dataTask.resume()
        
    }
    
}


