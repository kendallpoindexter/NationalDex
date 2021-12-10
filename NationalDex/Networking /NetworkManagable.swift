//
//  NetworkManagable.swift
//  NationalDex
//
//  Created by Kendall Poindexter on 12/9/21.
//  Copyright © 2021 Kendall Poindexter. All rights reserved.
//

import Foundation
import Combine

//How would we handle decoding errors using combine 
protocol NetworkManagable {
    func fetchData<T: Decodable>(with url: URL, type: T.Type) -> AnyPublisher<T, Error>
}

enum NetworkManagerErrors: Error {
    case httpResponseError(statusCode: Int)
}

struct URLSessionManager: NetworkManagable {
    func fetchData<T: Decodable>(with url: URL, type: T.Type) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.isHttpResponseValid else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: type, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
