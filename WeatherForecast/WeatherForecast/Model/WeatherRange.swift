//
//  WeatherRange.swift
//  WeatherForecast
//
//  Created by Blu on 2023/03/14.
//

import Foundation

enum WeatherRange: CustomStringConvertible {
    case current, forecast

    var description: String {
        switch self {
        case .current:
            return "weather"
        case .forecast:
            return "forecast"
        }
    }
}
