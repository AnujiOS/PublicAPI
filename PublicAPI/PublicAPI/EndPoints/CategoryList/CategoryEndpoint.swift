//
//  CategoryEndpoint.swift
//  PublicAPI
//
//  Created by Anuj Joshi on 30/04/2021.
//

import Foundation

enum CategoryEndpoint {
    case all
}

extension CategoryEndpoint: Endpoint {

    var basePath: String {
        return "https://api.publicapis.org/"
    }

    var headers: Headers {
        return ["Content-Type": "application/json"]
    }

    var method: Method {
        return .get
    }

    var path: String {
        return "categories"
    }

//    var queries: [String: String] {
//        return ["expand": "1", "limit" : "75"]
//    }
}
