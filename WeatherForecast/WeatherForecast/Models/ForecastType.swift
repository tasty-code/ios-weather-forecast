//
//  ForecastTyp.swift
//  WeatherForecast
//
//  Created by 김경록 on 11/21/23.
//

import Foundation

enum ForecastType: String {
    case current = "weather"
    case forecast = "forecast"
    
    func makeURL(lon: Double, lat: Double) -> URL? {
        guard let apiKey = Bundle.main.apiKey else {
            return nil
        }
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/\(self.rawValue)?lat=\(lon)&lon=\(lat)&appid=\(apiKey)&units=metric")
        return url
    }
}
