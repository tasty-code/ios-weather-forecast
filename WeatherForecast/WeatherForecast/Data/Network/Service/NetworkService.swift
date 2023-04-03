//
//  NetworkService.swift
//  WeatherForecast
//
//  Created by Bora Yang on 2023/03/20.
//

import Foundation

// MARK: - Protocols

protocol NetworkServiceProtocol {
    typealias APICompletion<T> = (Result<T, NetworkError>) -> Void
    
    func fetchWeather(lat: String, lon: String, completion: @escaping APICompletion<WeatherResponseDTO>)
    func fetchForecast(lat: String, lon: String, completion: @escaping APICompletion<ForecastResponseDTO>)
}

// MARK: - NetworkService

class NetworkService: NetworkServiceProtocol {

    func fetchWeather(lat: String, lon: String, completion: @escaping APICompletion<WeatherResponseDTO>) {
        request(lat: lat, lon: lon, path: NetworkConfig.URLPath.weather.rawValue, completion: completion)
    }

    func fetchForecast(lat: String, lon: String, completion: @escaping APICompletion<ForecastResponseDTO>) {
        request(lat: lat, lon: lon, path: NetworkConfig.URLPath.forecast.rawValue, completion: completion)
    }
}

// MARK: - Methods

extension NetworkServiceProtocol {
    func request<T: Decodable> (lat: String, lon: String, path: String, completion: @escaping APICompletion<T>) {

        guard let url = makeURL(path: path, lat: lat, lon: lon) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.transportError))
                return
            }

            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                completion(.failure(.serverError))
                return
            }

            guard let safeData = data else {
                completion(.failure(.missingData))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: safeData)
                completion(.success(decodedData))
                return
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }

    func makeURL(path: String, lat: String, lon: String) -> URL? {
        
        var urlComponents = URLComponents(string: "\(NetworkConfig.baseURL)/\(path)")
        
        let latQuery = URLQueryItem(name: "lat", value: lat)
        let lonQuery = URLQueryItem(name: "lon", value: lon)
        let appIdQuery = URLQueryItem(name: "appid", value: SecretKey.appId)
        let langQuery = URLQueryItem(name: "lang", value: "kr")
        
        return urlComponents?.url
    }
}
