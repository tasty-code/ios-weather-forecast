//
//  OpenWeatherURLProtocol.swift
//  WeatherForecast
//
//  Created by 신동오 on 2023/03/21.
//

import Foundation

protocol OpenWeatherURLProtocol {
    var BaseURL: String { get }
    var lat: Double { get }
    var lon: Double { get }
    var appid: String { get }
    
    func weatherURL(lat: Double, lon: Double) -> String
    func forecastURL(lat: Double, lon: Double) -> String
}

extension OpenWeatherURLProtocol {
    var BaseURL: String {
        return "https://api.openweathermap.org/data/2.5/"
    }
    var appid: String {
        return Bundle.main.apiKey
    }
    
    func weatherURL(lat: Double, lon: Double) -> String {
        return "\(BaseURL)weather?lat=\(lat)&lon=\(lon)&appid=\(appid)"
    }
    
    func forecastURL(lat: Double, lon: Double) -> String {
        return "\(BaseURL)forecast?lat=\(lat)&lon=\(lon)&appid=\(appid)"
    }
}
