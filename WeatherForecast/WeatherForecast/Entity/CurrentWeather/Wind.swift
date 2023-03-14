//
//  Wind.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/14.
//

import Foundation

struct Wind {
    let speed: Double
    let degree: Double
    
    private enum CodingKeys: String, CodingKey {
        case degree = "deg"
    }
}
