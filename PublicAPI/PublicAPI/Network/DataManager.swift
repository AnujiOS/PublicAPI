//
//  DataManager.swift
//  PublicAPI
//
//  Created by Anuj Joshi on 29/04/2021.
//

import Foundation

class DataManager {

    static var baseURL = "https://api.publicapis.org/"

    static func fetchCategories(completionHandler: @escaping ([String]) -> Void) {
        guard let url = URL(string: baseURL + "categories") else { return }

        let session = URLSession.shared.dataTask(with: url) { (data, res, error) in
            if let error = error {
                print(error)
                return
            }

            guard let data = data else { return }

            do {
                let categories = try JSONDecoder().decode([String].self, from: data)
              //  categories.insert("All", at: 0)

                completionHandler(categories)
            } catch let error {
                print(error)
            }

        }

        session.resume()
    }

    static func fetchEntries(category: String? = nil, completionHandler: @escaping ([Entry]) -> Void) {
        var url: URL?

        if var category = category {
            if category != "All" {
                category = category.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? category
                url = URL(string: baseURL + "entries?category=\(category)")
            } else {
                url = URL(string: baseURL + "entries")
            }
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
