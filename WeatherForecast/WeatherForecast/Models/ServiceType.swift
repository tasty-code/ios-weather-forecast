//
//  File.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/20/23.
//

import Foundation

enum ServiceType {
    case weather, forecast
    
    var name: String {
        switch self {
        case .weather: "weather"
        case .forecast: "forecast"
        }
    }
}
