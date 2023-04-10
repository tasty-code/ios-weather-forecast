//
//  WeatherParser.swift
//  WeatherForecast
//
//  Created by Blu on 2023/03/15.
//

import Foundation
import UIKit

struct WeatherParser<T: WeatherComposable> {
    static func parseWeatherData(at coordinate: CurrentCoordinate) async throws -> T {
        guard var request = requestData(for: T.weatherRange, at: coordinate) else {
            throw WeatherNetworkError.requestFailed(T.weatherRange.description)
        }
        
        request.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: request)
        let weatherData = try JSONDecoder().decode(T.self, from: data)

        return weatherData
    }

    static func parseWeatherIcon(with iconCode: String) async throws -> UIImage? {
        guard var request = requestIcon(with: iconCode) else {
            throw WeatherNetworkError.requestFailed("\(iconCode)번 아이콘")
        }

        request.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: request)
        let weatherIcon = UIImage(data: data)

        return weatherIcon
    }
    
    static func requestData(for weather: WeatherRange, at coordinate: CurrentCoordinate) -> URLRequest? {
        return try? URLRequest(url: URLService.makeDataURL(at: coordinate, weatherRange: weather))
    }

    static func requestIcon(with iconCode: String) -> URLRequest? {
        return try? URLRequest(url: URLService.makeIconURL(with: iconCode))
    }
}
