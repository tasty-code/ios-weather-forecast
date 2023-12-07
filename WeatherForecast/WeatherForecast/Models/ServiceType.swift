//
//  File.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/20/23.
//

import Foundation
import CoreLocation

enum ServiceType {
    case weather(coordinate: CLLocationCoordinate2D, apiKey: String)
    case forecast(coordinate: CLLocationCoordinate2D, apiKey: String)
    case icon(code: String)
    
    var urlComponents: URLComponents? {
        switch self {
        case .weather, .forecast:
            return URLComponents(string: "https://api.openweathermap.org/data/2.5/\(self.urlPath)")
        case .icon(let code):
            return URLComponents(string: "https://openweathermap.org/\(self.urlPath)/\(code)@2x.png")
        }
    }
    
    var urlPath: String {
        switch self {
        case .weather: "weather"
        case .forecast: "forecast"
        case .icon: "img/wn/"
        }
    }
    
    var urlQueries: [URLQueryItem] {
        switch self {
        case .weather(let coordinate, let apiKey), .forecast(let coordinate, let apiKey):
            [
                URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
                URLQueryItem(name: "lon", value: "\(coordinate.longitude)"),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric")
            ]
        default: []
        }
    }
    
    func makeURL() -> URL? {
        var urlComponents = self.urlComponents
        urlComponents?.queryItems = self.urlQueries
        return urlComponents?.url
    }
}
