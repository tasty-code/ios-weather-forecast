//
//  URLService.swift
//  WeatherForecast
//
//  Created by Blu on 2023/03/14.
//

import Foundation

enum URLService: String {
    case data = "data/2.5/"
    case icon = "img/wn/"

    private static let dataBaseURL = "https://api.openweathermap.org/"
    private static let iconBaseURL = "https://openweathermap.org/"
    private static let measurementUnit = "metric"
    private static let language = "kr"

    static func makeDataURL(at coordinate: CurrentCoordinate, weatherRange: WeatherRange) throws -> URL {
        var components = URLComponents(string: dataBaseURL)
        components?.path.append(data.rawValue)
        components?.path.append(weatherRange.description)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
            URLQueryItem(name: "lon", value: "\(coordinate.longitude)"),
            URLQueryItem(name: "units", value: measurementUnit),
            URLQueryItem(name: "lang", value: language),
            URLQueryItem(name: "appid", value: Bundle.main.apiKey)
        ]
        
        guard let url = components?.url else {
            throw WeatherNetworkError.invalidURL
        }
        
        return url
    }

    static func makeIconURL(with iconCode: String) throws -> URL {
        var components = URLComponents(string: iconBaseURL)
        components?.path.append(icon.rawValue)
        components?.path.append("\(iconCode)@2x.png")

        guard let url = components?.url else {
            throw WeatherNetworkError.invalidURL
        }

        return url
    }
}
