//
//  WeatherURL.swift
//  WeatherForecast
//
//  Created by BOMBSGIE on 2023/11/21.
//

import Foundation

enum WeatherURL: URLProtocol {
    static var url = "https://api.openweathermap.org"
    
    case current
    case weekly
    
    var path: String {
        switch self {
        case .current:
            return "weather"
        case .weekly:
            return "forecast"
        }
    }
}

