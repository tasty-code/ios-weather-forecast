//
//  WeatherType.swift
//  WeatherForecast
//
//  Created by 김경록 on 11/21/23.
//

import Foundation

enum WeatherType: String {
    case current = "weather"
    case forecast = "forecast"
    
    func fetchURL(lon: Double, lat: Double) -> String {
        guard let apiKey = Bundle.main.apiKey else {
            print("API KEY를 찾을 수 없습니다!!")
            return ""
        }

        return "https://api.openweathermap.org/data/2.5/\(self.rawValue)?lat=\(lon)&lon=\(lat)&appid=\(apiKey)"
    }
}
