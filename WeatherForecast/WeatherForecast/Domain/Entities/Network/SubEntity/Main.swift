//
//  Main.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/14.
//

import Foundation

struct Main: Decodable {
    let temperature: Double
    let feelsLike: Double
    let temperatureMin: Double
    let temperatureMax: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int?
    let groundLevel: Int?
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
        case pressure
        case humidity
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
    }
}
