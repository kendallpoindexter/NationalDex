//
//  DetailViewModel.swift
//  NationalDex
//
//  Created by Kendall Poindexter on 5/13/20.
//  Copyright © 2020 Kendall Poindexter. All rights reserved.
//

import Foundation

//Why have this be a delegate protocol
protocol DetailViewModelDelegate: AnyObject  {
    func reloadUI()
}

class DetailViewModel {
    private let networkManager = NetworkManager()
    let pokedexEntry: PokedexEntry
    var pokemon: Pokemon?
    private(set) var error: Error?
    weak var delegate: DetailViewModelDelegate?
    
    init(pokedexEntry: PokedexEntry) {
        self.pokedexEntry = pokedexEntry
    }
    
    func pokedexEntryURLFetched() {
        let entryURL = pokedexEntry.url
        networkManager.fetchPokemon(urlString: entryURL) { result in
            switch result {
            case .success(let decodedPokemon):
                //difference between unwrap and optional chaining/binding
                self.pokemon = decodedPokemon
                DispatchQueue.main.async {
                    self.delegate?.reloadUI()
                }
            case .failure(let error):
                self.error? = error
            }
        }
    }
}

