//
//  WeatherURL.swift
//  WeatherForecast
//
//  Created by BOMBSGIE on 2023/11/21.
//

import Foundation

enum WeatherURL: CustomStringConvertible {
    case current
    case weekly
    
    var description: String {
        switch self {
        case .current:
            return "https://api.openweathermap.org/data/2.5/weather?"
        case .weekly :
            return "https://api.openweathermap.org/data/2.5/forecast?"
        }
    }
}
