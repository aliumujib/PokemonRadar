//
//  SelectorCollectionViewCell.swift
//  PokemonRadar
//
//  Created by Abdul-Mujib Aliu on 6/3/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import UIKit

class SelectorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonImage: UIImageView!
    
    @IBOutlet weak var pokemonName: UILabel!
    
    var screenWidth : CGFloat!
    var screenHeight : CGFloat!

    
    override func awakeFromNib() {
        screenHeight = UIScreen.main.bounds.size.height
        screenWidth = UIScreen.main.bounds.size.width
    }
    
    func alignment()  {
        pokemonImage.frame = CGRect(x: 10, y: 10, width: (screenWidth/5) - 20, height: (screenWidth/5) - 20)
        
        pokemonName.frame = CGRect(x: 10, y: (screenWidth/5) + 10 , width: (screenWidth/5) - 20, height: (screenWidth/5) - 20)
    }
    
    func bindPokemon(pokeId : Int) {
        
        let pokeImage = UIImage(named: "\(pokeId+1)")
         let pokeName = pokemon[pokeId]
    
        pokemonImage.image = pokeImage
        pokemonName.text = pokeName
    }
    
}
