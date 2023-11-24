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
    
    func getURL(api: forecastType, latitude: Double, longitude: Double) -> URL? {
        let baseURL = "https://api.openweathermap.org/data/2.5/" + api.rawValue
        var makeURL = URLComponents(string: baseURL)
        makeURL?.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        guard let url = makeURL?.url else {
            return nil
        }
        return url
    }
}


