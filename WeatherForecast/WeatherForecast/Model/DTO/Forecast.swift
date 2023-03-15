//
//  Forecast.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/13.
//

import Foundation

// MARK: - Forecast
struct Forecast: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Decodable {
    let id: Int
    let name: String
    let coord: Coordinate
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}

// MARK: - List
struct List: Decodable {
    let dt: Int
    let main: MainData
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let dtTxt: String
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain
        case dtTxt = "dt_txt"
    }
}

// MARK: - Rain
struct Rain: Decodable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}
