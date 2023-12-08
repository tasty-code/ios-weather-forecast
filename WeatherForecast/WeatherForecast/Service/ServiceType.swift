//
//  ApiClient.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/21/23.
//
import Foundation
import CoreLocation

enum ServiceType {
    case forecast(coordinate: CLLocationCoordinate2D)
    case today(coordinate: CLLocationCoordinate2D)
    case icon(code: String)
    
    var urlPath: String {
        switch self {
        case .forecast:
            return "forecast/"
        case .today:
            return "weather/"
        case .icon:
            return "img/wn/"
        }
    }
    
    var componenets: URLComponents? {
        let components = URLComponents()
        switch self {
        case .forecast, .today:
            return URLComponents(string: "https://api.openweathermap.org/data/2.5/\(self.urlPath)")
        case .icon(code: let code):
            return URLComponents(string: "https://openweathermap.org/\(self.urlPath)\(code)@2x.png")
        }
    }
    
    var queryItems: [URLQueryItem] {
        let apiKey = "9025fdb78bf735a4b7287e0dcc03e4fd"
        switch self {
        case .forecast(coordinate: let coord), .today(coordinate: let coord):
            let latQueryItem = URLQueryItem(name: "lat", value: String(coord.latitude))
            let lonQueryItem = URLQueryItem(name: "lon", value: String(coord.longitude))
            let apiKeyQueryItem = URLQueryItem(name: "appid", value: apiKey)
            return [latQueryItem, lonQueryItem, apiKeyQueryItem]
        default:
            return []
        }
    }
    
    func makeURL() -> URL? {
        var compoenets = self.componenets
        compoenets?.queryItems = queryItems
        return componenets?.url
    }
}
