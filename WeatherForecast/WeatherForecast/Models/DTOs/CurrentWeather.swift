//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

struct CurrentWeather: Decodable {
    let dateTime: Int
    let main: Main
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case main, weather
        case dateTime = "dt"
    }
}
