//
//  FiveDayForecast.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

// MARK: - FiveDayForecast
struct FiveDayForecast: Decodable {
    let cod: String
    let message, cnt: Int
    let list: [Forecast]
    let city: City
}

// MARK: - List
struct Forecast: Decodable {
    let dateTime: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let rain, snow: Moisture?
    let visibility: Int
    let sys: SystemData
    let pop: Double
    let dateTimeText: String

    enum CodingKeys: String, CodingKey {
        case main, weather, clouds, wind, visibility, pop, rain, sys, snow
        case dateTime = "dt"
        case dateTimeText = "dt_txt"
    }
}

// MARK: - City
struct City: Decodable {
    let id: Int
    let name: String
    let coord: Coordinate
    let country: String
    let population, timezone, sunrise, sunset: Int
}
