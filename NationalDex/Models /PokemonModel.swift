//
//  Pokemon.swift
//  NationalDex
//
//  Created by Kendall Poindexter on 5/12/20.
//  Copyright © 2020 Kendall Poindexter. All rights reserved.
//

import Foundation

struct Pokemon {
    let name: String
    let abilities: [Ability]
    let types: [String]
}

struct PokemonResponse: Decodable {
    let name: String
    let abilities: [AbilityResponse]
    let types: [TypeResponse]
}

struct Ability {
    let name: String
    let effects: [Effect]
}

struct AbilityResponse: Decodable {
    let ability: PokeAbility
    
}

struct PokeAbility: Decodable {
    let name: String
    let url: String
}

struct EffectResponse: Decodable {
    let effects: [Effect]
    
    enum CodingKeys: String, CodingKey {
        case effects = "effect_entries"
    }
}

struct Effect: Decodable {
    let longDescription: String
    let shortDescription: String
    
    enum CodingKeys: String, CodingKey {
        case longDescription = "effect"
        case shortDescription = "short_effect"
    }
}

struct TypeResponse: Decodable {
    let type: Type
}

struct Type: Decodable {
    let name: String
}
