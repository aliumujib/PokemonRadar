//
//  CustomAnnotationPoint.swift
//  PokemonRadar
//
//  Created by Abdul-Mujib Aliu on 6/4/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import Foundation
import Mapbox

class CustomAnnotation: MGLPointAnnotation {
    
    private var _pokeId: Int!
    
    var pokeId: Int{
        return _pokeId
    }
    
    func setPokeID(pokeId: Int) {
        self._pokeId = pokeId
    }
   
    
    
}
