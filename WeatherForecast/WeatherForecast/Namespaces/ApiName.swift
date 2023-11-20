//
//  ApiName.swift
//  WeatherForecast
//
//  Created by 전성수 on 11/20/23.
//

import Foundation

enum ApiName {
    case openWeatherMap
    
    var name: String {
        switch self {
        case .openWeatherMap: "OpenWeatherMapKey"
        }
    }
}
