//
//  DataType.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/22/23.
//

import Foundation

enum WeatherType {
    case forecast
    case weatherToday
    
    var path: String {
        switch self {
        case .forecast:
            return "forecast/"
        case .weatherToday:
            return "weather/"
        }
    }
    
    var model: Decodable.Type {
        switch self {
        case .forecast:
            return WeatherForecast.self
        case .weatherToday:
            return WeatherToday.self
        }
    }
}
