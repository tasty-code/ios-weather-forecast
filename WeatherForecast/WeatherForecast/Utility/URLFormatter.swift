//
//  URLFormatter.swift
//  WeatherForecast
//
//  Created by BOMBSGIE on 2023/11/21.
//

import Foundation

struct URLFormatter: URLFormattable {
    typealias T = WeatherURL
    
    func makeURL(urlType: T, with queryDict: [String: String]) -> URL? {
        let urlString = "\(urlType)"
        var urlComponents = URLComponents(string: urlString)
        let queryItems = queryDict.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
}
