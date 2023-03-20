//
//  OpenWeatherRepository.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/14.
//

import Foundation

final class OpenWeatherRepository {
    
    //MARK: - Property
    
    private let deserializer: Deserializerable
    private let service: ServiceProtocol
    
    //MARK: - LifeCycle

    init(
        deserializer: Deserializerable,
        service: ServiceProtocol
    ) {
        self.deserializer = deserializer
        self.service = service
    }

    // MARK: - Constant
    
    private enum Constant {
        static let baseURL = "https://api.openweathermap.org"

        static let weatherPath = "/data/2.5/weather"
        static let forecastPath = "/data/2.5/forecast"

        static let latitudeQueryName = "lat"
        static let longitudeQueryName = "lon"
        static let appIdQueryName = "appid"
    }

    // MARK: - Public

    func fetchWeather(coordinate: Coordinate,
                      completion: @escaping (Result<CurrentWeather, NetworkError>) -> Void) {
        let url = generateURL(
            withPath: Constant.weatherPath,
            coordinate: coordinate
        )

        service.performRequest(with: url) { result in
            switch result {
            case .success(let data):
                do {
                    let weatherData = try self.deserializer.deserialize(CurrentWeather.self, data: data)
                    completion(.success(weatherData))
                } catch {
                    completion(.failure(.parseError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchForecast(coordinate: Coordinate,
                       completion: @escaping (Result<Forecast, NetworkError>) -> Void) {
        let url = generateURL(
            withPath: Constant.forecastPath,
            coordinate: coordinate
        )

        service.performRequest(with: url) { result in
            switch result {
            case .success(let data):
                do {
                    let forecastData = try self.deserializer.deserialize(Forecast.self, data: data)
                    completion(.success(forecastData))
                } catch {
                    completion(.failure(.parseError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Private

    private func generateURL(withPath path: String,
                             coordinate: Coordinate) -> URL? {
        guard var urlComponents = URLComponents(string: Constant.baseURL) else {
            return nil
        }

        urlComponents.path = path
        urlComponents.queryItems = generateQueryItems(coordinate: coordinate)

        return urlComponents.url
    }

    private func generateQueryItems(coordinate: Coordinate) -> [URLQueryItem] {
        return [
            URLQueryItem(name: Constant.latitudeQueryName, value: "\(coordinate.latitude)"),
            URLQueryItem(name: Constant.longitudeQueryName, value: "\(coordinate.longitude)"),
            URLQueryItem(name: Constant.appIdQueryName, value: "\(Bundle.main.apiKey)")
        ]
    }
}
