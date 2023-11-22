//
//  DataType.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/22/23.
//

import Foundation

enum DataType: CustomStringConvertible {
    case forecast
    case weatherToday
    
    var description: String {
        switch self {
        case .forecast:
            return "forecast/"
        case .weatherToday:
            return "weather/"
        }
    }
}
