//
//  WeatherParser.swift
//  WeatherForecast
//
//  Created by Blu on 2023/03/15.
//

import Foundation
import UIKit

struct WeatherParser {
    static func parseData<T: WeatherComposable>(at coordinate: CurrentCoordinate, type: T.Type) async throws -> T {
        guard let request = WeatherRouter.data(weatherRange: T.weatherRange, coordinate: coordinate).request else {
            throw WeatherNetworkError.requestFailed(T.weatherRange.description)
        }

        let (data, _) = try await URLSession.shared.data(for: request)
        let weatherData = try JSONDecoder().decode(T.self, from: data)

        return weatherData
    }

    static func parseIcon(with iconCode: String) async throws -> UIImage? {
        guard let request = WeatherRouter.icon(iconCode: iconCode).request else {
            throw WeatherNetworkError.requestFailed("\(iconCode)번 아이콘")
        }

        let (data, _) = try await URLSession.shared.data(for: request)
        let weatherIcon = UIImage(data: data)

        return weatherIcon
    }
}
