//
//  Service.swift
//  Pokedex
//
//  Created by Anzhela Baroyan on 31.03.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

class Service {
    static let shared = Service()
    
    let BASE_URL = "https://pokedex-bb36f.firebaseio.com/pokemon.json"
    
    func fetchPokemon(complition: @escaping([Pokemon]) -> ()){
        
        var pokemonArray = [Pokemon]()
        guard let url = URL(string: BASE_URL) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, responce, error ) in
            
            //handle error
            if let error = error{
                print ("Failed to fetch data with error: ", error.localizedDescription)
                return
            }
            
            guard let data = data else {return}
            
            do{
                guard let resultArray = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] else {return}
                
                for (key, result) in resultArray.enumerated(){
                    if let dictionary = result as? [String: AnyObject]{
                        let pokemon = Pokemon(id: key, dictionary: dictionary)
                        
                        guard let imageUrl = pokemon.imageUrl else {return}
                        
                        self.fetchImage(withUrlString: imageUrl) { (image) in
                            pokemon.image = image
                            pokemonArray.append(pokemon)
                            
                            pokemonArray.sort { (poke1, poke2) -> Bool in
                                return poke1.id! < poke2.id!
                            }

                            complition(pokemonArray)
                        }
                    }
                }
                
            } catch let error {
                print ("Failed to create json with errror: ", error.localizedDescription)}
            
        }.resume()
    }
    
    
    private func fetchImage(withUrlString urlString: String, completion: @escaping(UIImage) -> ()){
       
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url){data, responce, error in
            
            if let error = error{
                print ("Failed to fetch image with error: ", error.localizedDescription)
                return
            }
            
            guard let data = data else {return}
            guard let image = UIImage(data: data) else {return}
            
            completion(image)
            
        }.resume()
        
    }
}
