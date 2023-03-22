//
//  Weather.swift
//  WeatherForecast
//
//  Created by Bora Yang on 2023/03/14.
//

import Foundation

struct Weather: Codable {
    let visibility, dt, timezone, id, cod: Int?
    let base, name: String?
    let coord: Coordinate?
    let weather: [WeatherElement]
    let main: Main?
    let wind: Wind?
    let rain: Rain?
    let clouds: Clouds?
    let sys: Sys?
}

struct Clouds: Codable {
    let all: Int?
}

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?

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

struct Rain: Codable {
    let the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

struct Sys: Codable {
    let type, id, sunrise, sunset: Int?
    let country: String?
}

struct WeatherElement: Codable {
    let id: Int?
    let main, description, icon: String?
}

struct Wind: Codable {
    let speed, gust: Double?
    let deg: Int?
}
