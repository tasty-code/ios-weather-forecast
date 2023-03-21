//
//  Bundle+.swift
//  WeatherForecast
//
//  Created by Mason Kim on 2023/03/14.
//

import Foundation

extension Bundle {
    
    var apiKey: String {
        guard let key = object(forInfoDictionaryKey: "OpenWeatherAPIKey") as? String else {
            return ""
        }
        return key
    }
    
}
