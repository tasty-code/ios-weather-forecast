//
//  ForecastWeather.swift
//  WeatherForecast
//
//  Created by 김경록 on 11/20/23.


import Foundation

// MARK: - ForecastWeather

struct ForecastWeather: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

// MARK: - City

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - List

struct List: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dtTxt: String
    let rain: Rain?
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain
    }
}

// MARK: - PartOfDay

struct PartOfDay: Codable {
    let pod: Pod
    
    enum Pod: String, Codable {
        case d = "d"
        case n = "n"
    }
}
