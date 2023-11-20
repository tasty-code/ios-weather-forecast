//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by 김수경 on 2023/11/20.
//

import Foundation

struct CurrentWeather: Decodable {
    var coord: Coord
    var weather: [Weather]
    var base: String
    var main: Main
    var visibility: Int
    var wind: Wind
    var clouds: Clouds
    var rain: Rain?
    var snow: Snow?
    var dt: Int
    var sys: Sys
    var timezone: Int
    var id: Int
    var name: String
    var cod: Int
}

// MARK: - Coord

struct Coord: Decodable {
    var lon: Double
    var lat: Double
}

// MARK: - Weather

struct Weather: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

// MARK: - Main

struct Main: Decodable {
    var temp: Double
    var feelsLike: Double
    var tempMin: Double
    var tempMax: Double
    var pressure: Int
    var humidity: Int
    var seaLevel: Int
    var grndLevel: Int
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Wind

struct Wind: Decodable {
    var speed: Double
    var deg: Int
    var gust: Double
}

// MARK: - Clouds

struct Clouds: Decodable {
    var all: Int
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

struct Sys: Decodable {
    var type: Int
    var id: Int
    var country: String
    var sunrise: Int
    var sunset: Int
}

