//
//  weatherMenu.swift
//  WeatherForecast
//
//  Created by 동준 on 11/21/23.
//

import Foundation

enum WeatherMenuType: CustomStringConvertible {
    case currentWeather
    case fiveDaysWeahter
    
    var description: String {
        switch self {
            case .currentWeather: "weather"
            case .fiveDaysWeahter: "forecast"
        }
    }
    
    
    
}
