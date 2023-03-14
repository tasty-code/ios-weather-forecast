//
//  CommonDTO.swift
//  WeatherForecast
//
//  Created by Mason Kim on 2023/03/14.
//

import Foundation

// MARK: - Coord
struct Coord: Decodable {
    let lon, lat: Double
}

// MARK: - Clouds
struct Clouds: Decodable {
    let all: Int
}

// MARK: - Main
struct Main: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
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
    let gust: Double
}
