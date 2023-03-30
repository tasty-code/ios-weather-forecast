//
//  NetworkConfig.swift
//  WeatherForecast
//
//  Created by Bora Yang on 2023/03/20.
//

import Foundation

struct NetworkConfig {
    
    static let baseURL = "https://api.openweathermap.org/data/2.5"
    
    enum URLPath: String {
        case weather
        case forecast
    }
}
