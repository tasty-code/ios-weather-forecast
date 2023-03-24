//
//  FiveDaysForecast.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/16.
//

import UIKit

struct FiveDaysForecastDTO: Codable {
    
    let list: [Day]
}

struct Day: Codable {
    
    let time: String
    let temperature: Temperature
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        
        case time = "dt_txt"
        case temperature = "main"
        case weather
    }
}

struct Temperature: Codable {
    
    let temperature, minimumTemperature, maximumTemperature: Double
    
    enum CodingKeys: String, CodingKey {
        
        case temperature = "temp"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
    }
}

struct Weather: Codable {
    let id: Double
    let main, description, icon: String
}


