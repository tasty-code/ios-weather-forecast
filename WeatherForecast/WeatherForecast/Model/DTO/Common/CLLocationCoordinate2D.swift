//
//  Coordinate.swift
//  WeatherForecast
//
//  Created by Mason Kim on 2023/03/14.
//

import Foundation

struct Coordinate: Decodable {
    let longitude: Double
    let latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
