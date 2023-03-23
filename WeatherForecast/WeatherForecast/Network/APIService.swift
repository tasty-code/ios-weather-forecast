//
//  APIService.swift
//  WeatherForecast
//
//  Created by Bora Yang on 2023/03/20.
//

import Foundation

protocol APIServiceProtocol {
    func fetchWeatherAPI(coordinate: Coordinate, completion: @escaping (Result<Weather, NetworkError>) -> Void)
    func fetchForecastAPI(coordinate: Coordinate, completion: @escaping (Result<Forecast, NetworkError>) -> Void)
}

extension APIServiceProtocol {
    
}

typealias APICompletion<T> = (Result<T, NetworkError>) -> Void

final class APIService: APIServiceProtocol {

    static let shared = APIService()

    private let baseURL = "https://api.openweathermap.org/data/2.5"

    private init() { }

    func fetchWeatherAPI(coordinate: Coordinate, completion: @escaping APICompletion<Weather>) {

        fetchAPI(coordinate: coordinate, path: URLPath.weather.rawValue, completion: completion)
    }

    func fetchForecastAPI(coordinate: Coordinate, completion: @escaping APICompletion<Forecast>) {

        fetchAPI(coordinate: coordinate, path: URLPath.forecast.rawValue, completion: completion)
    }
}

extension APIService {
    private func fetchAPI<T: Decodable>(coordinate: Coordinate, path: String, completion: @escaping APICompletion<T>) {

        guard let url = makeURL(path: path, coordinate: coordinate) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let safeData = data, error == nil else {
                completion(.failure(.networkError))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: safeData)
                completion(.success(decodedData))
                return
            } catch {
                completion(.failure(.parseError))
                return
            }
        }.resume()
    }

    private func makeURL(path: String, coordinate: Coordinate) -> URL? {
        guard let lat = doubleToString(coordinate.lat),
              let lon = doubleToString(coordinate.lon) else { return nil }

        return URL(string: "\(baseURL)/\(path)?lat=\(lat)&lon=\(lon)&appid=\(SecretKey.appId)&lang=kr")
    }

    private func doubleToString(_ number: Double?) -> String? {
        guard let number else { return nil }
        return String(number)
    }
}
