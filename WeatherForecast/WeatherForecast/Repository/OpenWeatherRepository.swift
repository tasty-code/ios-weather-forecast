//
//  OpenWeatherRepository.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/14.
//

import Foundation

final class OpenWeatherRepository {

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
        performRequest(with: url, completion: completion)
    }

    func fetchForecast(coordinate: Coordinate,
                       completion: @escaping (Result<Forecast, NetworkError>) -> Void) {
        let url = generateURL(
            withPath: Constant.forecastPath,
            coordinate: coordinate
        )
        performRequest(with: url, completion: completion)
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

    private func performRequest<T: Decodable>(with url: URL?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url else {
            completion(.failure(.invalidURL))
            return
        }

        let decoder = JSONDecoder()

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.networkingError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.responseError))
                return
            }

            guard let data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
}
