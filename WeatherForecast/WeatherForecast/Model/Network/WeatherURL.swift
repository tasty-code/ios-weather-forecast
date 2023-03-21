//
//  WeatherURL.swift
//  WeatherForecast
//
//  Created by Blu on 2023/03/14.
//

import Foundation

enum WeatherURL {
    private static var baseURL = URLComponents(string: "https://api.openweathermap.org/data/2.5/")
    private static let measurementUnit = "metric"
    private static let language = "kr"

    static func make(at coordinate: CurrentCoordinate, weatherRange: WeatherRange) throws -> URL {
        baseURL?.path.append(weatherRange.description)
        baseURL?.queryItems = [
            URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
            URLQueryItem(name: "lon", value: "\(coordinate.longitude)"),
            URLQueryItem(name: "units", value: measurementUnit),
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "appid", value: Bundle.main.apiKey)
        ]
        
        guard let url = baseURL?.url else { throw WeatherNetworkError.invalidURL }
        
        return url
    }

    static func request(for weather: WeatherRange, at coordinate: CurrentCoordinate) -> URLRequest? {
        return try? URLRequest(url: make(at: coordinate, weatherRange: weather))
    }
}
