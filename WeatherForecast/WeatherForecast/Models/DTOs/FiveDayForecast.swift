//
//  FiveDayForecast.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

// MARK: - FiveDayForecast
struct FiveDayForecast: Codable {
    let cod: String
    let message, cnt: Int
    let list: [Forecast]
    let city: City
}

// MARK: - List
struct Forecast: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let snow: Snow?
    let visibility: Int
    let rain: Rain?
    let sys: Sys
    let pop: Double
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys, snow
        case dtTxt = "dt_txt"
    }
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}
