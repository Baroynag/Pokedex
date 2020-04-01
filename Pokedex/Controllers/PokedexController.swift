//
//  PokedexController.swift
//  Pokedex
//
//  Created by Anzhela Baroyan on 30.03.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
private let reuseIdentifier = "PokedexCell"

class PokedexController: UICollectionViewController {
    //MARK: - Properties
    
    private var pokemon = [Pokemon]()
    private var filteredPokemon = [Pokemon]()
    private var inSearchMode = false
    private var searchBar: UISearchBar!
    
    //MARK: - Inits
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        fetchPokemon()
        
    }
    
    //MARK: - Selectors
    
    @objc private func showSearchBar(){
        configureSearchBar()
    }
    
    //MARK: - API
    
    private func fetchPokemon() {
        
        Service.shared.fetchPokemon { (pokemon) in
            DispatchQueue.main.async {
                self.pokemon = pokemon
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - Helper functions
    
    private func configureViewComponents(){
        
        navigationController?.navigationBar.barTintColor = .mainPink()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Pokedex"
       
        configureSearchBarButton()
        
        collectionView.backgroundColor = .white
        collectionView.register(PokedexCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func configureSearchBar(){
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.tintColor = .white
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
        
    }
    
    private func configureSearchBarButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
    }
    
}


extension PokedexController{

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return inSearchMode ? filteredPokemon.count : pokemon.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokedexCell
        
        cell.pokemon = inSearchMode ? filteredPokemon[indexPath.row] : pokemon[indexPath.row]
            
        return cell
    }
    
    
}

extension PokedexController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 32, left: 8, bottom: 8, right: 8)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 36) / 3
        
        return CGSize(width: width, height: width)
    }
}

extension PokedexController: UISearchBarDelegate{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        configureSearchBar()
        inSearchMode = false
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" || searchBar.text == nil {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            filteredPokemon = pokemon.filter({ ($0.name?.range(of: searchText.lowercased()) != nil)})
            collectionView.reloadData()
        }
        
    }
    

    
}
