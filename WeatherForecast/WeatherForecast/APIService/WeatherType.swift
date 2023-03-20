//
//  WeatherType.swift
//  WeatherForecast
//
//  Created by Bora Yang on 2023/03/20.
//

import Foundation

enum WeatherType {
    case currentWeather
    case fiveDayWeather

    var urlString: String {
        switch self {
        case .currentWeather:
            return "https://api.openweathermap.org/data/2.5/weather"
        case .fiveDayWeather:
            return "https://api.openweathermap.org/data/2.5/forecast"
        }
    }
}
