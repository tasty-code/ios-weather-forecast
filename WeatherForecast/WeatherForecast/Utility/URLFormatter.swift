//
//  URLFormatter.swift
//  WeatherForecast
//
//  Created by BOMBSGIE on 2023/11/21.
//

import Foundation

struct URLFormatter<T: URLProtocol>: URLFormattable {
    func makeURL(path: String, with queries: [String: String]) -> URL? {
        let urlString = "\(T.url)"
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.path = "\(path)"
        let queryItems = queries.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
}

