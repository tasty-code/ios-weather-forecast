//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by 김경록 on 11/20/23.
//

import Foundation

// MARK: - CurrentWeather

struct CurrentWeather: Codable {
    let coord: Coordinate
    let weather: [Weather]
    let base: String?
    let main: WeatherCondition
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds

struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord

struct Coordinate: Codable {
    let longitude, latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

// MARK: - Main

struct WeatherCondition: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    let seaLevel, grndLevel: Int?
    let tempKf: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain

struct Rain: Codable {
    let the1H: Double?
    let the3H: Double?
    
    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
        case the3H = "3h"
    }
}

// MARK: - Sys

struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather

struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}
