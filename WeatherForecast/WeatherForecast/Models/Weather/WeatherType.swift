//
//  WeatherType.swift
//  WeatherForecast
//
//  Created by 김진웅 on 11/24/23.
//

import Foundation

enum WeatherType: CustomStringConvertible {
    case current
    case forecast
    
    var description: String {
        switch self {
        case .current: return "weather"
        case .forecast: return "forecast"
        }
    }
}
