//
//  ViewController.swift
//  NationalDex
//
//  Created by Kendall Poindexter on 5/11/20.
//  Copyright © 2020 Kendall Poindexter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sample test code to make sure we are getting proper network calls
        NetworkManager().fetchPokedexEntries { result in
            switch result {
            case .success(let pokedex):
                NetworkManager().fetchPokemon(urlString: pokedex.results[1].url) { (result) in
                    switch result {
                    case .success(let pokemon):
                        print(pokemon)
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print("Opps \(error)")
            }
        }
    }


}

