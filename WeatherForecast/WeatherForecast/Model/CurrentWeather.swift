//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by 김수경 on 2023/11/20.
//

import Foundation

struct CurrentWeather: Decodable {
    var coordinate: Coordinate?
    var weather: [Weather]?
    var base: String?
    var main: Main?
    var visibility: Int?
    var wind: Wind?
    var clouds: Clouds?
    var rain: Rain?
    var snow: Snow?
    var dataTime: Int?
    var system: System?
    var timezone: Int?
    var id: Int?
    var name: String?
    var cod: Int?
    
    enum CodingKeys: String, CodingKey {
        case weather, base, main, visibility, wind, clouds, rain, snow, timezone, id, name, cod
        case coordinate = "coord"
        case dataTime = "dt"
        case system = "sys"
    }
}

// MARK: - Coord

struct Coordinate: Decodable {
    var longitude: Double
    var latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

// MARK: - Weather

struct Weather: Decodable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

// MARK: - Main

struct Main: Decodable {
    var temperature: Double?
    var feelsLike: Double?
    var minTemperature: Double?
    var maxTemperature: Double?
    var pressure: Int?
    var humidity: Int?
    var seaLevel: Int?
    var groundLevel: Int?
    
    enum CodingKeys: String, CodingKey {
        case pressure, humidity
        case temperature = "temp"
        case feelsLike = "feels_like"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
    }
}

// MARK: - Wind

struct Wind: Decodable {
    var speed: Double?
    var direction: Int?
    var gust: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed, gust
        case direction = "deg"
    }
}

// MARK: - Clouds

struct Clouds: Decodable {
    var all: Int?
}

// MARK: - Rain

struct Rain: Decodable {
    var oneHour: Double?
    var threeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHour = "3h"
    }
}

// MARK: - Snow

struct Snow: Decodable {
    var oneHour: Double?
    var threeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHour = "3h"
    }
}

// MARK: - Sys

struct System: Decodable {
    var type: Int?
    var id: Int?
    var country: String?
    var sunrise: Int?
    var sunset: Int?
}

