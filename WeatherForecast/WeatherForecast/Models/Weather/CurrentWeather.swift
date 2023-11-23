//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by 김경록 on 11/20/23.
//

import Foundation

// MARK: - CurrentWeather

struct CurrentWeather: Decodable {
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

struct Clouds: Decodable {
    let all: Int
}

// MARK: - Coord

struct Coordinate: Decodable {
    let longitude, latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

// MARK: - Main

struct WeatherCondition: Decodable {
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

struct Rain: Decodable {
    let amountOfRainOneHour: Double?
    let amountOfRainThreeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case amountOfRainOneHour = "1h"
        case amountOfRainThreeHour = "3h"
    }
}

// MARK: - Sys

struct Sys: Decodable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather

struct Weather: Decodable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind

struct Wind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double?
}
