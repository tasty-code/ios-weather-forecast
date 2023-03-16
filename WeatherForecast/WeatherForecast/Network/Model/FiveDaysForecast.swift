//
//  FiveDaysForecast.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/16.
//

import UIKit

struct FiveDaysForecast: Codable {
    let list: [Day]
    let city: City
    
}

struct City: Codable {
    let coordinate: Coordinate
    let name: String
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
    
    enum CodingKeys: String, CodingKey {
        case name, country, population, timezone, sunrise, sunset
        case coordinate = "coord"
    }
}

struct Day: Codable {
    let time: String
    let weatherData: WeatherData
    let visibility: Int
    let pop: Double
    
    enum CodingKeys: String, CodingKey {
        case visibility, pop
        case time = "dt_txt"
        case weatherData = "main"
    }
}

struct WeatherData: Codable {
    let temperature, sensoryTemperature, minimumTemperature, maximumTemperature: Double
    let pressure, seaLevel, groundLevel, humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case sensoryTemperature = "feels_like"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
        case humidity
    }
}


