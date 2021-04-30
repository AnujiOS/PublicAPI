//
//  CategoryDetailsService.swift
//  PublicAPI
//
//  Created by Anuj Joshi on 30/04/2021.
//

import Foundation

class CategoryDetailsService: NetworkService {

    static func fetchEntries(category: String? = nil, completionHandler: @escaping ([Entry]) -> Void) {
        var url: URL?

        if var category = category {
                category = category.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? category
                url = URL(string: CategoryDetailsEndpoint.all.basePath + CategoryDetailsEndpoint.all.path + category)
        }

        guard let fetchURL = url else { return }

        let session = URLSession.shared.dataTask(with: fetchURL) { (data, res, error) in
            if let error = error {
                print(error)
                return
            }

            guard let data = data else { return }

            do {
                let res = try JSONDecoder().decode(APIResponse.self, from: data)
                let entries = res.entries

                completionHandler(entries)
            } catch let error {
                print(error)
            }

        }

        session.resume()
    }
}
