//
//  WeatherRouter.swift
//  WeatherForecast
//
//  Created by Blu on 2023/03/14.
//

import Foundation

enum WeatherRouter {
    case data(weatherRange: WeatherRange, coordinate: CurrentCoordinate)
    case icon(iconCode: String)
    
    private var scheme: String {
        return "https"
    }
    
    private var host: String {
        switch self {
        case .data(_, _): return "api.openweathermap.org"
        case .icon(_): return "openweathermap.org"
        }
    }
    
    private var path: String {
        switch self {
        case let .data(range, _):
            return "/data/2.5/" + range.description
        case let .icon(code):
            return "/img/wn/" + code + "@2x.png"
        }
    }
    
    private var query: [URLQueryItem] {
        switch self {
        case let .data(_, coordinate):
            return [
                URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
                URLQueryItem(name: "lon", value: "\(coordinate.longitude)"),
                URLQueryItem(name: "units", value: String.weatherMeasurementUnit),
                URLQueryItem(name: "lang", value: String.weatherDataLanguage),
                URLQueryItem(name: "appid", value: Bundle.main.apiKey)
            ]
        case .icon(_):
            return []
        }
    }
    
    private var method: String {
        return "GET"
    }
}

extension WeatherRouter {
    private var url: URL? {
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = self.path
        
        if !self.query.isEmpty {
            components.queryItems = self.query
        }
        
        return components.url
    }
    
    var request: URLRequest? {
        guard let url = self.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method
        
        return request
    }
}
