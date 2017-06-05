//
//  File.swift
//  Awesome Notes
//
//  Created by Abdul-Mujib Aliu on 5/7/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

let SELECTOR_CELL_REUSE_ID = "SELECTOR_COLLECTION_VIEW_CELL"
let SHOW_SELECTOR_SEGUE = "SHOW_SELECTOR_SEGUE"

let DATE_CREATION_KEY = "created_date"

let PARSE_POKEMON_SIGHTING_TABLE_NAME = "Pokemon"
let PARSE_POKEMON_SIGHTING_POKEMON_NAME = "pokemon_name"
let PARSE_POKEMON_SIGHTING_POKEMON_ID = "pokemon_id"
let PARSE_POKEMON_SIGHTING_LOCATION = "location"


let SHADOW_COLOR : UIColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0)
let PRIMARY_COLOR : UIColor = UIColor(red: 250.0/255.0, green: 121.0/255.0, blue: 44.0/255.0, alpha: 1)
let TEXTFIELD_BORDER_COLOR : UIColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)


let BASE_GOOGLE_MAP_REQ_URL = "https://maps.googleapis.com/maps/api/geocode/json"
let LAT_LNG = "latlng"
let MAPS_API_KEY = "AIzaSyBNWUaBcDOtOolzz77u_aBGjvPCNg6Itx0"

func getReverseGeoCodeURL(cordinate: CLLocationCoordinate2D) -> String {
    return "\(BASE_GOOGLE_MAP_REQ_URL)?\(LAT_LNG)=\(cordinate.latitude),\(cordinate.longitude)&\(MAPS_API_KEY)"
}

typealias RequestCompleted = () -> ()

let pokemon = [
    "bulbasaur",
    "ivysaur",
    "venusaur",
    "charmander",
    "charmeleon",
    "charizard",
    "squirtle",
    "wartortle",
    "blastoise",
    "caterpie",
    "metapod",
    "butterfree",
    "weedle",
    "kakuna",
    "beedrill",
    "pidgey",
    "pidgeotto",
    "pidgeot",
    "rattata",
    "raticate",
    "spearow",
    "fearow",
    "ekans",
    "arbok",
    "pikachu",
    "raichu",
    "sandshrew",
    "sandslash",
    "nidoran-f",
    "nidorina",
    "nidoqueen",
    "nidoran-m",
    "nidorino",
    "nidoking",
    "clefairy",
    "clefable",
    "vulpix",
    "ninetales",
    "jigglypuff",
    "wigglytuff",
    "zubat",
    "golbat",
    "oddish",
    "gloom",
    "vileplume",
    "paras",
    "parasect",
    "venonat",
    "venomoth",
    "diglett",
    "dugtrio",
    "meowth",
    "persian",
    "psyduck",
    "golduck",
    "mankey",
    "primeape",
    "growlithe",
    "arcanine",
    "poliwag",
    "poliwhirl",
    "poliwrath",
    "abra",
    "kadabra",
    "alakazam",
    "machop",
    "machoke",
    "machamp",
    "bellsprout",
    "weepinbell",
    "victreebel",
    "tentacool",
    "tentacruel",
    "geodude",
    "graveler",
    "golem",
    "ponyta",
    "rapidash",
    "slowpoke",
    "slowbro",
    "magnemite",
    "magneton",
    "farfetchd",
    "doduo",
    "dodrio",
    "seel",
    "dewgong",
    "grimer",
    "muk",
    "shellder",
    "cloyster",
    "gastly",
    "haunter",
    "gengar",
    "onix",
    "drowzee",
    "hypno",
    "krabby",
    "kingler",
    "voltorb",
    "electrode",
    "exeggcute",
    "exeggutor",
    "cubone",
    "marowak",
    "hitmonlee",
    "hitmonchan",
    "lickitung",
    "koffing",
    "weezing",
    "rhyhorn",
    "rhydon",
    "chansey",
    "tangela",
    "kangaskhan",
    "horsea",
    "seadra",
    "goldeen",
    "seaking",
    "staryu",
    "starmie",
    "mr-mime",
    "scyther",
    "jynx",
    "electabuzz",
    "magmar",
    "pinsir",
    "tauros",
    "magikarp",
    "gyarados",
    "lapras",
    "ditto",
    "eevee",
    "vaporeon",
    "jolteon",
    "flareon",
    "porygon",
    "omanyte",
    "omastar",
    "kabuto",
    "kabutops",
    "aerodactyl",
    "snorlax",
    "articuno",
    "zapdos",
    "moltres",
    "dratini",
    "dragonair",
    "dragonite",
    "mewtwo",
    "mew"]
