//
//  JSONFormatter.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/30/23.
//

import Foundation

final class JSONFormatter: JSONDecodable {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    func decodeJSON<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        do {
            let decodedData = try decoder.decode(type, from: data)
            return decodedData
        } catch {
            guard let error = error as? DecodingError else { return nil }
            print("Failed to Decoding JSON: \(error)")
        }
        
        return nil
    }
}
