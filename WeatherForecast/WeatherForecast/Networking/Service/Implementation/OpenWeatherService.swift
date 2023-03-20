//
//  OpenWeatherService.swift
//  WeatherForecast
//
//  Created by Mason Kim on 2023/03/20.
//

import Foundation

final class OpenWeatherService: ServiceProtocol {
    func performRequest(with url: URL?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url else {
            completion(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.networking))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.response))
                return
            }

            guard let data else {
                completion(.failure(.invalidData))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
}
