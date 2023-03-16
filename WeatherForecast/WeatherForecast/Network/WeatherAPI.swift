//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/14.
//

import UIKit

enum WeatherAPI: String {
    case currentWeather
    case fiveDaysForecast
    
    var decodingType: Codable.Type {
        switch self {
        case .currentWeather:
            return CurrentWeather.self
        case .fiveDaysForecast:
            return FiveDaysForecast.self
        }
    }
    
    static let baseURL = "https://api.openweathermap.org"
    var path: String {
        switch self {
        case .currentWeather:
            return "/data/2.5/weather?"
        case .fiveDaysForecast:
            return "/data/2.5/forecast?"
        }
    }
}

extension WeatherAPI {
    
    func makeWeatherURL(coordinate: Coordinate) -> URL {
        let queryItems = "\(coordinate.description)&units=metric&appid="
        let apiKey = APIKeyManager.openWeather.apiKey
        
        return URL(string: WeatherAPI.baseURL + self.path + queryItems + apiKey)!
    }
}
