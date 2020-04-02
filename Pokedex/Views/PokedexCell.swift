//
//  PokedexCell.swift
//  Pokedex
//
//  Created by Anzhela Baroyan on 30.03.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

protocol PokedexCellDelegate {

    func presentInfoView(withPokemon pokemon: Pokemon)
    
}

class PokedexCell: UICollectionViewCell {
    
    //MARK: - Properties

    var delegate: PokedexCellDelegate?
    
    var pokemon: Pokemon?{
        didSet{
            
            nameLabel.text = pokemon?.name
            imageView.image = pokemon?.image
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray5
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy private var nameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainPink()
        view.addSubview(nameLabel)
        nameLabel.center(inView: view)
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "bulbasaur"
        return label
    }()
    
    //MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer){
        if sender.state == .began{
            guard let pokemon = self.pokemon else {return}
            delegate?.presentInfoView(withPokemon: pokemon)
        }
    }
    
    //MARK: - Hepler functions
    
    private func configureViewComponents(){
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: self.frame.height - 32)
        
        addSubview(nameContainerView)
        nameContainerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
}
