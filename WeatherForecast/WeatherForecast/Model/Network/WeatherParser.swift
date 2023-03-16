//
//  WeatherParser.swift
//  WeatherForecast
//
//  Created by Blu on 2023/03/15.
//

import Foundation

struct WeatherParser<T: WeatherComposable> {
    static func parse(at coordinate: Coordinate) async throws -> T {
        guard let request = WeatherURL.request(for: T.weatherRange, at: coordinate) else {
            throw WeatherError.invalidRequest
        }

        let (data, _) = try await URLSession.shared.data(for: request)
        let weatherData = try JSONDecoder().decode(T.self, from: data)

        return weatherData
    }
}
