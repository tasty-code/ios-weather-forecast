//
//  File.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/20/23.
//

import Foundation
import CoreLocation

enum ServiceType {
    case weather(coordinate: CLLocationCoordinate2D, apiKey: String), forecast(coordinate: CLLocationCoordinate2D, apiKey: String)
    
    var urlComponents: URLComponents? {
        return URLComponents(string: "https://api.openweathermap.org/data/2.5/\(self.urlPath)")
    }
    
    var urlPath: String {
        switch self {
        case .weather: "weather"
        case .forecast: "forecast"
        }
    }
    
    var urlQueries: [URLQueryItem] {
        switch self {
        case .weather(let coordinate, let apiKey):
            [
                URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
                URLQueryItem(name: "lon", value: "\(coordinate.longitude)"),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric")
            ]
        case .forecast(let coordinate, let apiKey):
            [
                URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
                URLQueryItem(name: "lon", value: "\(coordinate.longitude)"),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric")
            ]
        }
    }
    
    var decodingType: Decodable.Type {
        switch self {
        case .weather: WeatherModel.self
        case .forecast: ForecastModel.self
        }
    }
    
    func makeURL() -> URL? {
        var urlComponents = self.urlComponents
        urlComponents?.queryItems = self.urlQueries
        return urlComponents?.url
    }
}
