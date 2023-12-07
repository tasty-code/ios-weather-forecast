//
//  JSONDecodable.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/30/23.
//

import Foundation

protocol JSONDecodable {
    func decodeJSON<T: Decodable>(_ type: T.Type, from data: Data) -> T?
}
