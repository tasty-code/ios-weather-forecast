//
//  BaseURLStorage.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/28/23.
//

import Foundation

protocol BaseURLResolvable {
    func resolve(for type: ApiType) -> URL?
}

protocol BaseURLStorable {
    func store(_ url: URL, for type: ApiType)
}

final class BaseURLStorage: BaseURLStorable, BaseURLResolvable {
    private var baseURLDictionary: [ApiType: URL] = [:]
    
    func store(_ url: URL, for type: ApiType) {
        baseURLDictionary[type] = url
    }
    
    func resolve(for type: ApiType) -> URL? {
        baseURLDictionary[type]
    }
}
