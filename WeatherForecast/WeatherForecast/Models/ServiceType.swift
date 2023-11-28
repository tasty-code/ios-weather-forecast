//
//  ServiceType.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/28/23.
//

import Foundation
import CoreLocation

enum ServiceType {
    case weather(coordinate: CLLocationCoordinate2D, apiKey: String)
    case forecast(coordinate: CLLocationCoordinate2D, apiKey: String)
    
    var path: String {
        switch self {
        case .weather: "weather"
        case .forecast: "forecast"
        }
    }
    
    var queries: [URLQueryItem] {
        switch self {
        case .weather(let coordinate, let apiKey), .forecast(let coordinate, let apiKey):
            [
                URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
                URLQueryItem(name: "lon", value: "\(coordinate.longitude)"),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "lang", value: "kr")
            ]
        }
    }
}
