//
//  NetworkService.swift
//  WeatherForecast
//
//  Created by Mason Kim on 2023/03/20.
//

import Foundation

final class NetworkService {

    func performRequest(with urlRequest: URLRequest?,
                        completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let urlRequest else {
            completion(.failure(.invalidURL))
            log(.network, error: NetworkError.invalidURL)
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(.networking))
                log(.network, error: NetworkError.networking)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.response))
                log(.network, error: NetworkError.response)
                return
            }

            guard let data else {
                completion(.failure(.invalidData))
                log(.network, error: NetworkError.invalidData)
                return
            }

            completion(.success(data))
        }
        task.resume()
    }

    func performRequest(with url: URL?,
                        httpMethodType: HTTPMethodType,
                        completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url else {
            completion(.failure(.invalidURL))
            log(.network, error: NetworkError.invalidURL)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethodType.rawValue
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(.networking))
                log(.network, error: NetworkError.networking)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.response))
                log(.network, error: NetworkError.response)
                return
            }

            guard let data else {
                completion(.failure(.invalidData))
                log(.network, error: NetworkError.invalidData)
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
}
