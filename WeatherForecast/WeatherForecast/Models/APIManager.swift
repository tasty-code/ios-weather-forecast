//
//  ApiKey.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 2023/11/20.
//

import Foundation

struct APIManager {
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "APIKey", ofType: "plist") else {
                fatalError("키가 들어있는 파일을 찾을수 없습니다.")
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "KEY") as? String else {
                fatalError("키파일안에 키를 찾을 수 없습니다")
            }
            return value
        }
    }
    
    enum forecastType : String {
        case weather = "weather"
        case forecast = "forecast"
    }
    
    func getWeather(api: forecastType, latitude: Double, longitude: Double) {
        var baseUrl = URLComponents(string: "https://api.openweathermap.org")
        baseUrl?.path = "/data/2.5/" + api.rawValue
        let latitude = URLQueryItem(name: "lat", value: "\(latitude)")
        let longitude = URLQueryItem(name: "lon", value: "\(longitude)")
        let units = URLQueryItem(name: "units", value: "metric")
        let apikey = URLQueryItem(name: "appid", value: "\(apiKey)")
        baseUrl?.queryItems = [latitude, longitude, units, apikey]
        guard let url = baseUrl?.url else {
            return
        }
    }
}


