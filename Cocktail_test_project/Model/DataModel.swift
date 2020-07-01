//
//  DataModel.swift
//  Cocktail_test_project
//
//  Created by Максим Котилевский on 30.06.2020.
//  Copyright © 2020 Максим Котилевский. All rights reserved.
//

import Foundation

// MARK: -  Drinks list
struct Drinks: Decodable {
    let drinks: [DrinkDataModel]
}

struct DrinkDataModel: Decodable {
    
       let strDrink: String
       let strDrinkThumb: String
       let idDrink: String
}

// MARK: - Filter of drinks
struct DrinkFilters: Decodable {
    let drinks: [Filters]
}

struct Filters: Decodable {
    let strCategory: String
    
}

