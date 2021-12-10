//
//  PokemonService.swift
//  NationalDex
//
//  Created by Kendall Poindexter on 12/10/21.
//  Copyright © 2021 Kendall Poindexter. All rights reserved.
//

import Foundation
import Combine
// should the service layer handle the building of internal types like ability

enum ServiceErrors: Error {
    case failedTransformation(error: Error)
}
struct PokemonService {
    private let networkManager: NetworkManagable
    
    init(networkManager: NetworkManagable) {
        self.networkManager = networkManager
    }
    
    private func fetchAbilities(from responses: [AbilityResponse]) -> [Ability]{
        var abilities = [Ability]()
        for response in responses {
            createAbility(from: response).tryMap { ability in
                abilities.append(ability)
            }
        }
        return abilities
    }
    
    // how would you handle a URL Error here
    private func createAbility(from response: AbilityResponse) -> AnyPublisher<Ability, Error> {
      let url = URL(string: response.ability.url)!
            return networkManager.fetchData(with: url, type: EffectResponse.self)
                .tryMap { effectResponse in
                    let ability = Ability(name: response.ability.name, effects: effectResponse.effects)
                    return ability
                }
                .eraseToAnyPublisher()
    }
}
