//
//  CurrenctWeather.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/14.
//

import Foundation

struct CurrentWeather: WeatherModel {
    let coordinator: Coordinate
    let weather: [Weather]
    let main: Main
    let visibility: Double
    let wind: Wind
    let clouds: Clouds
    let rain: Rain?
    let snow: Snow?
    let TimeOfDataCalculation: Double
    let sys: WeatherSystem
    let timezone: Int
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case coordinator = "coord"
        case weather
        case main
        case visibility
        case wind
        case clouds
        case rain
        case snow
        case TimeOfDataCalculation = "dt"
        case sys
        case timezone
        case id
        case name
    }
}
