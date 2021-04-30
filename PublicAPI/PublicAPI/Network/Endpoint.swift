//
//  Endpoint.swift
//  PublicAPI
//
//  Created by Anuj Joshi on 30/04/2021.
//

import Foundation

enum URLConvertibleError: Error {
    case notConvertible
}

typealias Parameters = [String: Any]
typealias Headers = [String: String]

enum Method: String {
    case get
    case post
    case delete
}

protocol Endpoint {
    var basePath: String { get }
    var headers: Headers { get }
    var method: Method { get }
    var path: String { get }
    var parameters: Parameters { get }
    var queries: [String: String] { get }
    func asURL() throws -> URL
    func asURLRequest() throws -> URLRequest
}

extension Endpoint {
    var parameters: Parameters { return [:] }
    var queries: [String: String] { return [:] }
    var headers: Headers { return [:] }

    func asURL() throws -> URL {
        guard let url = URL(string: basePath) else {
            throw URLConvertibleError.notConvertible
        }
        return url.appendingPathComponent(path)
    }

    private func fullUrl() throws -> URL {
        let url = try asURL()
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

        if !queries.isEmpty {
            components?.queryItems = queries.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }

        return components?.url ?? url
    }

    func asURLRequest() throws -> URLRequest {

        var request = try URLRequest(url: fullUrl(), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        request.httpMethod = method.rawValue

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        if !parameters.isEmpty {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }

        return request
    }
}
