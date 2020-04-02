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
    
    let infoView: InfoView = {
        let view = InfoView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .blue
        return view
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
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
    
    @objc func handleDismissal() {
        dismissInfoView(pokemon: nil)
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
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        visualEffectView.alpha = 0
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        visualEffectView.addGestureRecognizer(gesture)
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
    
    func dismissInfoView(pokemon: Pokemon?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.infoView.alpha = 0
            self.infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.infoView.removeFromSuperview()
        }
    }
    
}

// MARK: - UICollectionViewDataSource/Delegate

extension PokedexController{

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return inSearchMode ? filteredPokemon.count : pokemon.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokedexCell
        
        cell.pokemon = inSearchMode ? filteredPokemon[indexPath.row] : pokemon[indexPath.row]
            
        cell.delegate = self
        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

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

//MARK: - UISearchBarDelegate
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

// MARK: - PokedexCellDelegate

extension PokedexController: PokedexCellDelegate {
    
    func presentInfoView(withPokemon pokemon: Pokemon) {
        view.addSubview(infoView)
        infoView.configureViewComponents()
        infoView.delegate = self
        infoView.pokemon = pokemon
        infoView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 64, height: 350)
        infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -44).isActive = true
        
        infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        infoView.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = 1
            self.infoView.alpha = 1
            self.infoView.transform = .identity
        }
    }
    
 
    
}

extension PokedexController: InfoViewDelegate {
    func dismissInfoView(withPokemon pokemon: Pokemon?) {
        dismissInfoView(pokemon: pokemon)
    }
    
}
