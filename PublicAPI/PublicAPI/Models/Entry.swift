//
//  Entry.swift
//  PublicAPI
//
//  Created by Anuj Joshi on 29/04/2021.
//

import Foundation

struct APIResponse: Codable {
    let count: Int
    let entries: [Entry]
}

struct Entry: Codable {
    let api: String
    let description: String
    let auth: String
    let https: Bool
    let cors: String
    let link: String
    let category: String

    enum CodingKeys: String, CodingKey {
        case api = "API"
        case description = "Description"
        case auth = "Auth"
        case https = "HTTPS"
        case cors = "Cors"
        case link = "Link"
        case category = "Category"
    }
}

enum Auth: String, Codable {
    case apiKey = "apiKey"
    case empty = ""
    case oAuth = "OAuth"
    case xMashapeKey = "X-Mashape-Key"
}

enum Cors: String, Codable {
    case no = "no"
    case unknown = "unknown"
    case yes = "yes"
}
