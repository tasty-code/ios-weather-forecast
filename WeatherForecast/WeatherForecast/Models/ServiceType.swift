//
//  File.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/20/23.
//

import Foundation

enum ServiceType: CustomStringConvertible {
    case weather, forecast
    
    var description: String {
        switch self {
        case .weather: "weather"
        case .forecast: "forecast"
        }
    }
}
