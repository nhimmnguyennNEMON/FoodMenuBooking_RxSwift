//
//  FoodModel.swift
//  RxSwiftBindSubOnNext
//
//  Created by V000273 on 08/09/2022.
//

import Foundation

struct Food {
    var name: String
    var image: String
    var price: String
    
    init(name: String, image: String, price: String) {
        self.name = name
        self.image = image
        self.price = price
    }
}
