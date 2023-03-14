//
//  Main.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/14.
//

import Foundation

struct Main {
    let temperature: Double
    let pressure: Int
    let humidity: Int
    let temperatureMin: Double
    let temperatureMax: Double
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
    }
}
