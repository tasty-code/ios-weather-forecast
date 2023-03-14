//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/14.
//

import UIKit

enum WeatherAPI: String {
    case currentWeather
    case fiveDaysForecast
    
    var urlComponent: String {
        switch self {
        case .currentWeather:
            return "weather"
        case .fiveDaysForecast:
            return "forecast"
        }
    }
}
