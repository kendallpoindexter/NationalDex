//
//  NetworkManager.swift
//  NationalDex
//
//  Created by Kendall Poindexter on 5/12/20.
//  Copyright © 2020 Kendall Poindexter. All rights reserved.
//

import Foundation
import PromiseKit

struct NetworkManager {
    enum Errors: Error {
        case NoDataRecieved
    }
    
    func fetchPokemon(urlString: String, completion: @escaping (Swift.Result<Pokemon, Error>) -> Void)  {
        firstly {
            fetchObjectFromData(urlString: urlString, type: PokemonResponse.self)
        }.then { pokemonResponse in
            self.fetchAbilities(from: pokemonResponse.abilities).map { (pokemonResponse, $0)}
        }.done { pokemonResponses, abilities in
            let types = self.fetchTypes(from: pokemonResponses.types)
            let pokemon = Pokemon(name: pokemonResponses.name, abilities: abilities, types: types)
            completion(.success(pokemon))
        }.catch { error in
            completion(.failure(error))
        }
    }
    
    
    func fetchPokedexEntries(completion: @escaping (Swift.Result<Pokedex, Error>) -> Void)  {
        let urlString = "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=150"
        
        firstly {
            fetchObjectFromData(urlString: urlString, type: Pokedex.self)
        }.done { pokedex in
            completion(.success(pokedex))
        }.catch { error in
            completion(.failure(error))
        }

    }
    
    private func fetchTypes(from responses: [TypeResponse]) -> [String] {
        let types = responses.map { $0.type.name }
        return types
    }
    
    private func fetchAbilities(from responses: [AbilityResponse]) ->  Promise<[Ability]>  {
        let abilityPromises = responses.map {
            createAbility(from: $0)
        }
        return Promise { seal in
            firstly {
                when(fulfilled: abilityPromises)
            }.done { abilities in
                seal.fulfill(abilities)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
        
    private func createAbility(from response: AbilityResponse)  -> Promise<Ability> {
        return Promise { seal in
            firstly {
                fetchObjectFromData(urlString: response.ability.url, type: EffectResponse.self)
            }.done { effectResponse in
                let ability = Ability(name: response.ability.name, effects: effectResponse.effects)
                seal.fulfill(ability)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    private func fetchObjectFromData<T:Decodable>(urlString: String, type: T.Type) -> Promise<T> {
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        
        return Promise { seal in
            guard let url = url else { return }
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    seal.reject(error)
                }else if let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode, let data = data {
                    do {
                        let decodedData = try self.decodeData(data: data, type: T.self)
                        seal.fulfill(decodedData)
                    } catch {
                        seal.reject(Errors.NoDataRecieved)
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func decodeData<T: Decodable>(data: Data, type: T.Type) throws -> T {
        let data = try JSONDecoder().decode(type, from: data)
        return data
    }
}
