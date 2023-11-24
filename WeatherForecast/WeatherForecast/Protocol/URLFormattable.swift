//
//  URLFormattable.swift
//  WeatherForecast
//
//  Created by BOMBSGIE on 2023/11/21.
//

import Foundation

protocol URLFormattable {
    associatedtype T: URLProtocol
    
    var defaultPath: String { get }
    
    func makeURL(path: String, with queries: [String: String]) -> URL?
}

extension URLFormattable {
    func makeURL(path: String, with queries: [String: String]) -> URL? {
        let urlString = "\(T.url)"
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.path = "\(defaultPath)\(path)"
        let queryItems = queries.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
}
