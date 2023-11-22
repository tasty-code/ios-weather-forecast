//
//  WeatherURLManager.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 2023/11/20.
//

import Foundation

struct WeatherURLManager {
    private var apiKey: String? {
        get {
            guard let filePath = Bundle.main.path(forResource: "APIKey", ofType: "plist") else {
                debugPrint(APIKeyError.keyFileNotFound.localizedDescription)
                return nil
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "KEY") as? String else {
                debugPrint(APIKeyError.keyNotFound.description)
                return nil
            }
            return value
        }
    }
    
    enum forecastType : String {
        case weather = "weather"
        case forecast = "forecast"
    }
    
    func getUrl(api: forecastType, latitude: Double, longitude: Double) -> URL? {
        var baseURL = URLComponents(string: "https://api.openweathermap.org")
        baseURL?.path = "/data/2.5/" + api.rawValue
        
        let latitude = URLQueryItem(name: "lat", value: "\(latitude)")
        let longitude = URLQueryItem(name: "lon", value: "\(longitude)")
        let units = URLQueryItem(name: "units", value: "metric")
        let apikey = URLQueryItem(name: "appid", value: apiKey)
        baseURL?.queryItems = [latitude, longitude, units, apikey]
        guard let url = baseURL?.url else {
            return nil
        }
        return url
    }
}


