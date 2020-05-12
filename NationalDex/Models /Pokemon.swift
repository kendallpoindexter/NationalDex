//
//  Pokemon.swift
//  NationalDex
//
//  Created by Kendall Poindexter on 5/12/20.
//  Copyright © 2020 Kendall Poindexter. All rights reserved.
//

import Foundation

struct Pokemon  {
    let name: String
    let height: Int
    let abilities: [Ability]
    let types: [Type]
}

struct Ability {
    let name: String
    let url: String
}

struct Type {
    let name: String
}
