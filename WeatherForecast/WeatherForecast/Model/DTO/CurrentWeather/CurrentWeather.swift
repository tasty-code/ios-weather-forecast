//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Mason Kim on 2023/03/13.
//

import Foundation

// MARK: - CurrentWeather
struct CurrentWeather: Decodable {
    let coordinate: Coordinate
    let weathers: [Weather]
    let base: String
    let weatherDetail: WeatherDetail
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let timestamp: Int
    let timezone, id: Int
    let cityName: String

    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weatherDetail = "main"
        case timestamp = "dt"
        case cityName = "name"
        case weathers = "weather"
        case base, visibility, wind, clouds, timezone, id
    }
}

