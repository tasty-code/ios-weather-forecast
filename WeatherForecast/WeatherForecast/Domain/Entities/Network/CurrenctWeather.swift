//
//  CurrenctWeather.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/14.
//

import Foundation

struct CurrentWeather: WeatherModel {
    let coordinator: Coordinate?
    let weathers: [Weather]
    let main: Main
    let visibility: Double?
    let wind: Wind?
    let clouds: Clouds?
    let rain: Rain?
    let snow: Snow?
    let timeOfDataCalculation: Double?
    let weatherSystem: WeatherSystem?
    let timezone: Int?
    let id: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case coordinator = "coord"
        case weathers = "weather"
        case main
        case visibility
        case wind
        case clouds
        case rain
        case snow
        case timeOfDataCalculation = "dt"
        case weatherSystem = "sys"
        case timezone
        case id
        case name
    }
}
