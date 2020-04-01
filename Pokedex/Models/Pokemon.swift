//
//  Pokemon.swift
//  Pokedex
//
//  Created by Anzhela Baroyan on 31.03.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

class Pokemon{
    
    var id: Int?
    var name: String?
    var imageUrl: String?
    var image: UIImage?
    var weight: Int?
    var height: Int?
    var defence: Int?
    var attack: Int?
    var description: String?
    var type: String?
    var baseExperience: Int?
    
    init (id: Int, dictionary: [String: AnyObject]){
        
        self.id = id
        
        if let name = dictionary["name"] as? String{
            self.name = name
        }
   
        if let imageUrl = dictionary["imageUrl"] as? String{
            self.imageUrl = imageUrl
        }
        if let weight = dictionary["weight"] as? Int{
            self.weight = weight
        }
        if let height = dictionary["height"] as? Int{
            self.height = height
        }
        if let defence = dictionary["defence"] as? Int{
            self.defence = defence
        }
        if let attack = dictionary["attack"] as? Int{
            self.attack = attack
        }
        if let description = dictionary["description"] as? String{
            self.description = description
        }
        if let type = dictionary["type"] as? String{
            self.type = type
        }
        if let baseExperience = dictionary["baseExperience"] as? Int{
            self.baseExperience = baseExperience
        }
        
    }
    
    
}
