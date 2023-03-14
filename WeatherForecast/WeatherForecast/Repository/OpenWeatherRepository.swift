//
//  OpenWeatherRepository.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/14.
//

import Foundation

final class OpenWeatherRepository {
    
    private enum Constant {
        static let baseURL = "https://api.openweathermap.org"

        static let weatherPath = "/data/2.5/weather"
        static let forecastPath = "/data/2.5/forecast"

        static let lattitudeQueryName = "lat"
        static let longitudeQueryName = "lon"
        static let appIdQueryName = "appid"
    }

    func fetchWeather(lattitude: Double, longitude: Double,
                      completion: @escaping (Result<CurrentWeather, NetworkError>) -> Void) {
        guard var urlComponents = URLComponents(string: Constant.baseURL) else {
            completion(.failure(.invalidURL))
            return
        }

        urlComponents.path = Constant.weatherPath
        urlComponents.queryItems = generateQueryItems(lattitude: lattitude, longitude: longitude)

        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        performRequest(with: url, completion: completion)
    }

    func fetchForecast(lattitude: Double, longitude: Double,
                       completion: @escaping (Result<Forecast, NetworkError>) -> Void) {
        guard var urlComponents = URLComponents(string: Constant.baseURL) else {
            completion(.failure(.invalidURL))
            return
        }

        urlComponents.path = Constant.forecastPath
        urlComponents.queryItems = generateQueryItems(lattitude: lattitude, longitude: longitude)

        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        performRequest(with: url, completion: completion)
    }

    private func generateQueryItems(lattitude: Double, longitude: Double) -> [URLQueryItem] {
         return [
            URLQueryItem(name: Constant.lattitudeQueryName, value: "\(lattitude)"),
            URLQueryItem(name: Constant.longitudeQueryName, value: "\(longitude)"),
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

    private func decodeToJson() {
        let decoder = JSONDecoder()
    }
    
    // JSONDecoding 분리
}
