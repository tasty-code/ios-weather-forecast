//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/03/21.
//

import UIKit
import CoreLocation

final class NetworkManager: OpenWeatherURLProtocol, NetworkTaskProtcol {
    
    // MARK: - Public
    func callWeatherAPI(latitude: Double, longitude: Double) async throws -> Weather? {
        let weatherURLString = weatherURL(lat: latitude, lon: longitude)
        let weatherURL = try getURL(string: weatherURLString)
        var weatherURLRequest = URLRequest(url: weatherURL)

        weatherURLRequest.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: weatherURLRequest)
        let weather = try JSONDecoder().decode(Weather.self, from: data)
        print("[NetworkManager](fetched)weather")
        return weather
    }

    func callForecastAPI(latitude: Double, longitude: Double) async throws -> Forecast? {
        let forecastURLString = forecastURL(lat: latitude, lon: longitude)
        let forecastURL = try getURL(string: forecastURLString)
        var forecastURLRequest = URLRequest(url: forecastURL)
        
        forecastURLRequest.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: forecastURLRequest)
        let forecast = try JSONDecoder().decode(Forecast.self, from: data)
        print("[NetworkManager](fetched)forecast")
        return forecast
    }

    func callWeatherIconAPI(weatherStatus: String) async throws -> UIImage? {
        let weatherIconURL = try getURL(string: "https://openweathermap.org/img/wn/\(weatherStatus)@2x.png")
        var weatherIconURLRequest = URLRequest(url: weatherIconURL)

        weatherIconURLRequest.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: weatherIconURLRequest)
        let weatherIconImage = UIImage(data: data)
        print("[NetworkManager](fetched)WeatherIcon")
        return weatherIconImage
    }

    func callForecastIconAPI(forecastList: [Forecast.List]) async throws -> [String: UIImage]? {
        var imageSet: [String: UIImage] = [:]

        for forecastCase in forecastList {
            if let forecastStatus = forecastCase.weather.first?.icon {
                let forecastIconURL = try getURL(string: "https://openweathermap.org/img/wn/\(forecastStatus)@2x.png")
                var forecastIconURLRequest = URLRequest(url: forecastIconURL)

                forecastIconURLRequest.httpMethod = "GET"

                let (data, _) = try await URLSession.shared.data(for: forecastIconURLRequest)

                imageSet[forecastStatus] = UIImage(data: data)
            }
        }

        print("[NetworkManager](fetched)ForecastIcon")
        return imageSet
    }

    // MARK: - Private
    private func getURL(string: String) throws -> URL {
        guard let weatherURL = URL(string: string) else {
            throw NetworkError.invalidURL
        }
        return weatherURL
    }
}
