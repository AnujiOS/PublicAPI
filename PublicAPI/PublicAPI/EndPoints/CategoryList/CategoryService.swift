//
//  CategoryService.swift
//  PublicAPI
//
//  Created by Anuj Joshi on 30/04/2021.
//

import Foundation

class CategoryService: NetworkService {
    
    func fetchCategories(with complete: @escaping (Result<[String]>) -> Void) {
        request(CategoryEndpoint.all){ result in
            switch result{
            case .success(let data):
                do {
                    let jsonData = JSONDecoder()
                    jsonData.dateDecodingStrategy = .iso8601

                    let decodeData = try jsonData.decode([String].self, from: data)
                    let category_list = decodeData
                    complete(.success(category_list))
                } catch {
                    print(LocalizedError.self)
                    complete(.failure(error))
                }
            case .failure(let error):
                complete(.failure(error))
            }
        }
    }
}
