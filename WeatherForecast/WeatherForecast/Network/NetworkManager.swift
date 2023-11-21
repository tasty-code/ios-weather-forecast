//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/21/23.
//

import Foundation

struct NetworkManager: ApiClient {
    var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/")
    
    init() {
        components?.path += "forecast/"
        let apiKey = URLQueryItem(name: "appid", value: Sequrity.weatherApiKey)
        components?.queryItems?.append(apiKey)
    }
    
    init(lat: Double, lon: Double) {
        components?.path += "weather/"
        let latQueryItem = URLQueryItem(name: "lat", value: String(lat))
        let lonQueryItem = URLQueryItem(name: "lon", value: String(lon))
        let apiKey = URLQueryItem(name: "appid", value: Sequrity.weatherApiKey)
        components?.queryItems = [latQueryItem, lonQueryItem, apiKey]
    }
}
