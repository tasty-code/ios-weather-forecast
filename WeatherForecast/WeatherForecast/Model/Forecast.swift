//
//  Forecast.swift
//  WeatherForecast
//
//  Created by Bora Yang on 2023/03/14.
//

import Foundation

struct Forecast: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

struct City: Codable {
    let name, country: String
    let id, population, timezone, sunrise, sunset: Int
    let coord: Coord
}

struct List: Codable {
    let dt, visibility: Int
    let pop: Double
    let dtTxt: String
    let main: Main
    let weather: [WeatherElement]
    let clouds: Clouds
    let wind: Wind
    let rain: ForecastRain?
    let sys: ForecastSys

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}

struct ForecastRain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct ForecastSys: Codable {
    let pod: String
}
