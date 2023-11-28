//
//  ApiName.swift
//  WeatherForecast
//
//  Created by 전성수 on 11/20/23.
//

import Foundation

enum ApiType{
    case openWeatherMap
    
    var name: String {
        switch self {
        case .openWeatherMap: "OpenWeatherMapKey"
        }
    }
    
    var baseURL: URL? {
        switch self {
        case .openWeatherMap: URL(string: "https://api.openweathermap.org/data/2.5/")
        }
    }
}
