//
//  Protocols.swift
//  Pokedex
//
//  Created by Anzhela Baroyan on 02.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

protocol PokedexCellDelegate {

    func presentInfoView(withPokemon pokemon: Pokemon)
    
}

protocol InfoViewDelegate {
    
    func dismissInfoView(withPokemon pokemon: Pokemon?)
    
}
