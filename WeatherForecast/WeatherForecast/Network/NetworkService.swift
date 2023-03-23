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
    
    func fetchWeatherAPI(coordinate: Coordinate, completion: @escaping APICompletion<Weather>)
    func fetchForecastAPI(coordinate: Coordinate, completion: @escaping APICompletion<Forecast>)
}

// MARK: - APIService

final class NetworkService: NetworkServiceProtocol {

    static let shared = NetworkService()

    private init() { }

    func fetchWeatherAPI(coordinate: Coordinate, completion: @escaping APICompletion<Weather>) {
        request(coordinate: coordinate, path: NetworkConfig.URLPath.weather.rawValue, completion: completion)
    }

    func fetchForecastAPI(coordinate: Coordinate, completion: @escaping APICompletion<Forecast>) {
        request(coordinate: coordinate, path: NetworkConfig.URLPath.forecast.rawValue, completion: completion)
    }
}

// MARK: - Methods

extension NetworkService {
    private func request<T: Decodable>(coordinate: Coordinate, path: String, completion: @escaping APICompletion<T>) {
        
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
        
        return URL(string: "\(NetworkConfig.baseURL)/\(path)?lat=\(lat)&lon=\(lon)&appid=\(SecretKey.appId)&lang=kr")
    }
    
    private func doubleToString(_ number: Double?) -> String? {
        guard let number else { return nil }
        return String(number)
    }
}
