//
//  HomeTableViewModel.swift
//  NationalDex
//
//  Created by Kendall Poindexter on 5/13/20.
//  Copyright © 2020 Kendall Poindexter. All rights reserved.
//

import Foundation

final class HomeTableViewModel {
    let networkManager = NetworkManager()
   private(set) var pokedexEntries: [PokedexEntry] = []
    
    func fetchPokedexEntries(completion: ((Result<[PokedexEntry],Error>) -> Void)? = nil)  {
        networkManager.fetchPokedexEntries { result in
            switch result {
            case .success(let pokedex):
                self.pokedexEntries = pokedex.results
                DispatchQueue.main.async {
                    completion?(.success(self.pokedexEntries))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion?(.failure(error))
                }
            }
        }
    }
}
