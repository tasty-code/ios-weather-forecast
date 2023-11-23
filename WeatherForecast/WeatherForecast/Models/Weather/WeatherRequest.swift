//
//  WeatherRequest.swift
//  WeatherForecast
//
//  Created by 김경록 on 11/21/23.
//

import Foundation

struct WeatherRequest: APIRequest {
    var scheme: String = "https"
    var host: String = "api.openweathermap.org"
    var method: String = "GET"
    
    var path: String
    var parameters: [String : String]?
    
    init?(latitude: Double, longitude: Double, forecastType: WeatherType) {
        self.path = "/data/2.5/\(forecastType)"
        
        guard let apiKey = Bundle.main.apiKey else { return }
        parameters = [
            "lon": "\(longitude)",
            "lat": "\(latitude)",
            "appid": apiKey,
            "units": "metric"
        ]
    }
}

enum WeatherType: String {
    case current = "weather"
    case forecast = "forecast"
}
