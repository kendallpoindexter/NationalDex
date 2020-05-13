//
//  PokedexModel.swift
//  NationalDex
//
//  Created by Kendall Poindexter on 5/11/20.
//  Copyright © 2020 Kendall Poindexter. All rights reserved.
//

import Foundation

struct Pokedex: Decodable {
     let results: [PokedexEntry]
}

struct PokedexEntry: Decodable, Hashable {
     let name: String
     let url: String
}
