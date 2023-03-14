//
//  FiveDayWeather.swift
//  WeatherForecast
//
//  Created by Bora Yang on 2023/03/14.
//

import Foundation

// MARK: - FiveDayWeather
struct FiveDayWeather: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Codable {
    let name, country: String
    let id, population, timezone, sunrise, sunset: Int
    let coord: Coord
}

// MARK: - List
struct List: Codable {
    let dt, visibility: Int
    let pop: Double
    let dtTxt: String
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let rain: FiveDayRain?
    let sys: FiveDaySys

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - FiveDayRain
struct FiveDayRain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - FiveDaySys
struct FiveDaySys: Codable {
    let pod: String
}
