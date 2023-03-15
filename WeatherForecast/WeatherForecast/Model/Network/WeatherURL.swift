//
//  WeatherURL.swift
//  WeatherForecast
//
//  Created by Blu on 2023/03/14.
//

import Foundation

enum WeatherURL {
    private static let baseURL = "https://api.openweathermap.org/data/2.5/"
    private static let apiKey = "33f6d884e30621345ee893c404cd9866"

    static func make(at coordinate: Coord, weatherRange: WeatherRange) throws -> URL {
        let query = ["lat=\(coordinate.lat)", "lon=\(coordinate.lon)", "appid=\(apiKey)"].joined(separator: "&")
        let urlString = baseURL + weatherRange.description + "?" + query

        guard let url = URL(string: urlString) else { throw WeatherError.invalidURL }

        return url
    }

    static func request(for weather: WeatherRange, at coordinate: Coord) -> URLRequest? {
        return try? URLRequest(url: make(at: coordinate, weatherRange: weather))
    }
}
