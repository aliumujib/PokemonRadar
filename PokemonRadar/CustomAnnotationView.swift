//
//  CustomAnnotationView.swift
//  PokemonRadar
//
//  Created by Abdul-Mujib Aliu on 6/3/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import Foundation
import Mapbox

//
// MGLAnnotationView subclass
class CustomAnnotationView: MGLAnnotationView {
    
 private   var _pokeId: Int!
 private   var _pokeName: String!
    
    var pokeId: Int{
        if(_pokeId == 0){
        
        }
        return _pokeId
    }
    
    
    var pokeName: String{
        if(_pokeName == nil){
            _pokeName = ""
        }
        return _pokeName
    }
    
    override func awakeFromNib() {
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }
    
    func bindPokeMonImage(id: Int) {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        let image = UIImage(named: "\(id+1)")
        _pokeId = id
        _pokeName = pokemon[id]
        imageView.image = image
        self.addSubview(imageView)
        print("MAKING IMAGE \(id)")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = 0
        layer.add(animation, forKey: "borderWidth")
    }
}
