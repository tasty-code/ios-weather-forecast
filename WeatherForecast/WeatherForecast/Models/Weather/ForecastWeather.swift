//
//  ForecastWeather.swift
//  WeatherForecast
//
//  Created by 김경록 on 11/20/23.

import Foundation

// MARK: - ForecastWeather

struct ForecastWeather: Decodable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

// MARK: - City

struct City: Decodable {
    let id: Int
    let name: String
    let coord: Coordinate
    let country: String
    let population, timezone, sunrise, sunset: Int?
}

// MARK: - List

struct List: Decodable {
    let dt: Int
    let weatherCondition: WeatherCondition
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let rainfallProbability: Double
    let rain: Rain?
    let partOfDay: PartOfDay
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, weather, clouds, wind, visibility, rain
        case dtTxt = "dt_txt"
        case partOfDay = "sys"
        case weatherCondition = "main"
        case rainfallProbability = "pop"
    }
}

// MARK: - PartOfDay

struct PartOfDay: Decodable {
    let pod: String
}
