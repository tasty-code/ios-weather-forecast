//
//  JSONDeserializer.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/16.
//

import Foundation

class JSONDesirializer: Deserializerable {
    
    private let decoder = JSONDecoder()
    
    func deserialize<T: Decodable>(_ type: T.Type, data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }
    
}
