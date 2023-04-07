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
    
    var decodingType: Decodable.Type {
        
        switch self {
        case .currentWeather:
            return CurrentWeatherDTO.self
            
        case .fiveDaysForecast:
            return FiveDaysForecastDTO.self
        }
    }
}

extension WeatherAPI {
    
    static let baseURL = "https://api.openweathermap.org"
    static let baseImageURL = "https://openweathermap.org"
    
    var path: String {
        
        switch self {
        case .currentWeather:
            return "/data/2.5/weather?"
            
        case .fiveDaysForecast:
            return "/data/2.5/forecast?"
        }
    }
    
    func makeWeatherURL(coordinate: Coordinate) -> URL {
        
        let queryItems = "\(coordinate.description)&units=metric&appid="
        let apiKey = APIKeyManager.openWeather.apiKey
        
        return URL(string: WeatherAPI.baseURL + self.path + queryItems + apiKey)!
    }
    
    static func makeImageURL(icon: String) -> URL {
        
        let path = "/img/wn/\(icon)@2x.png"
        
        return URL(string: WeatherAPI.baseImageURL + path)!
    }
}
