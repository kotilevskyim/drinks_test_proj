//
//  Category.swift
//  Cocktail_test_project
//
//  Created by Максим Котилевский on 30.06.2020.
//  Copyright © 2020 Максим Котилевский. All rights reserved.
//

import Foundation

struct Category {
    let name: String
    let drinks: [DrinkItem]
    
}

struct DrinkItem {
    var name: String
    var image: Data?
    var id: String
    
    init(name: String, imageUrl: String, id: String) {
        self.name = name
        self.id = id
        
        let url = URL(string: imageUrl)
        let imgData = try? Data(contentsOf: url!)
        image = imgData
    }
    
   
    
}


