//
//  WeatherRainDTO.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/04.
//

import Foundation

struct WeatherRainDTO: Decodable {
    let the1H: Double?
    
    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}
