//
//  NetworkService.swift
//  PublicAPI
//
//  Created by Anuj Joshi on 30/04/2021.
//

import Foundation

enum NetworkServiceError: Error {
    case invalidURL
    case network(Error?)
    case unexpectedResponse
}

class NetworkService {
    enum Result<Value> {
        case success(Value)
        case failure(Error)
    }

    private let engine: NetworkEngine

    init(engine: NetworkEngine = URLSession.shared) {
        self.engine = engine
    }

    func request(for endpoint: Endpoint) throws -> URLRequest {
        return try endpoint.asURLRequest()
    }

    func request(_ endpoint: Endpoint, then complete: @escaping (Result<Data>) -> Void) {
        do {
            let urlRequest = try request(for: endpoint)
            engine.performRequest(for: urlRequest) { data, _, error in

                guard error == nil else {
                    complete(Result.failure(NetworkServiceError.network(error)))
                    return
                }

                complete(Result.success(data!))
            }
        } catch {
            complete(.failure(NetworkServiceError.invalidURL))
        }
    }
}

