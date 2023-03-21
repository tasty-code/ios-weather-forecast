//
//  Wind.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/14.
//

import Foundation

struct Wind: Decodable {
    let speed: Double
    let degree: Double
    let gust: Double?
    
    private enum CodingKeys: String, CodingKey {
        case speed
        case degree = "deg"
        case gust
    }
}
