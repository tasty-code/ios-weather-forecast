//
//  WeatherURL.swift
//  WeatherForecast
//
//  Created by 김경록 on 11/21/23.
//

import Foundation
enum WeatherURL {
    case currentWeatherURL(latitude: Double ,longitude: Double, apiKey: String)
    case forecastWeatherURL(latitude: Double ,longitude: Double, apiKey: String)
    
    var link: String {
        switch self {
        case.currentWeatherURL(latitude: let latitude, 
                               longitude: let longitude,
                               apiKey: let apiKey):
            return "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        case.forecastWeatherURL(latitude: let latitude, 
                                longitude: let longitude, 
                                apiKey: let apiKey):
            return "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        }
    }
}
