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
    
//    func fetchWeatherAPI(_ coordinate: Coordinate, completion: @escaping APICompletion<WeatherEntitiy>)
//    func fetchForecastAPI(_ coordinate: Coordinate, completion: @escaping APICompletion<ForecastEntity>)
}

// MARK: - NetworkService

class NetworkService: NetworkServiceProtocol {

//    func fetchWeatherAPI(_ coordinate: Coordinate, completion: @escaping APICompletion<WeatherEntitiy>) {
//        request(coordinate: coordinate, path: NetworkConfig.URLPath.weather.rawValue, completion: completion)
//    }
//
//    func fetchForecastAPI(_ coordinate: Coordinate, completion: @escaping APICompletion<ForecastEntity>) {
//        request(coordinate: coordinate, path: NetworkConfig.URLPath.forecast.rawValue, completion: completion)
//    }
}

// MARK: - Methods

extension NetworkServiceProtocol {
//    func request<T: Decodable> (coordinate: Coordinate, path: String, completion: @escaping APICompletion<T>) {
//
//        guard let url = makeURL(path: path, coordinate: coordinate) else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard error == nil else {
//                completion(.failure(.transportError))
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse,
//                  (200...299).contains(response.statusCode) else {
//                completion(.failure(.serverError))
//                return
//            }
//
//            guard let safeData = data else {
//                completion(.failure(.missingData))
//                return
//            }
//
//            do {
//                let decodedData = try JSONDecoder().decode(T.self, from: safeData)
//                completion(.success(decodedData))
//                return
//            } catch {
//                completion(.failure(.decodingError))
//                return
//            }
//        }.resume()
//    }
//
//    func makeURL(path: String, coordinate: Coordinate) -> URL? {
//        guard let lat = coordinate.lat?.doubleToString(),
//              let lon = coordinate.lon?.doubleToString() else { return nil }
//        return URL(string: "\(NetworkConfig.baseURL)/\(path)?lat=\(lat)&lon=\(lon)&appid=\(SecretKey.appId)&lang=kr")
//    }
}
