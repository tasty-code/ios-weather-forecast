//
//  ApiClient.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/21/23.
//

import Foundation

struct ApiClient {
    private static let baseURL = "https://api.openweathermap.org/data/2.5/"
    
    static func makeURL(lat: Double, lon: Double, weatherType: WeatherType) -> URL? {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        var components = URLComponents(string: baseURL)
        components?.path += weatherType.path
        
        let latQueryItem = URLQueryItem(name: "lat", value: String(lat))
        let lonQueryItem = URLQueryItem(name: "lon", value: String(lon))
        let apiKeyQueryItem = URLQueryItem(name: "appid", value: apiKey)
        components?.queryItems = [latQueryItem, lonQueryItem, apiKeyQueryItem]
        
        return components?.url
    }
}
