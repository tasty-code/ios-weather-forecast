//
//  Deserializerable.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/16.
//

import Foundation

protocol Deserializerable {
    func deserialize<T: Decodable>(_ type: T.Type, data: Data) throws -> T
}
