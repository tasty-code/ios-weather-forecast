//
//  ApiClient.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/21/23.
//

import Foundation

struct ApiClient {
    private static let baseURL = "https://api.openweathermap.org/data/2.5/"
    
    static func makeURL(lat: Double, lon: Double, dataType: DataType) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.path += dataType.description
        let latQueryItem = URLQueryItem(name: "lat", value: String(lat))
        let lonQueryItem = URLQueryItem(name: "lon", value: String(lon))
        let apiKey = URLQueryItem(name: "appid", value: Sequrity.weatherApiKey)
        components?.queryItems = [latQueryItem, lonQueryItem, apiKey]
        
        return components?.url
    }
}
