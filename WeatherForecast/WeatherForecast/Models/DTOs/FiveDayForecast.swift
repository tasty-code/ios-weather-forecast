//
//  FiveDayForecast.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

// MARK: - FiveDayForecast
struct FiveDayForecast: Decodable {
    let cnt: Int
    let list: [Forecast]
}

// MARK: - List
struct Forecast: Decodable {
    let main: Main
    let weather: [Weather]
    let dateTimeText: String

    enum CodingKeys: String, CodingKey {
        case main, weather
        case dateTimeText = "dt_txt"
    }
}
