//
//  NetworkService.swift
//  WeatherForecast
//
//  Created by Mason Kim on 2023/03/20.
//

import Foundation
import OSLog

final class NetworkService: ServiceProtocol {

    func performRequest(with url: URL?,
                        httpMethodType: HTTPMethodType,
                        completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url else {
            completion(.failure(.invalidURL))
            log(with: .invalidURL)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethodType.rawValue
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard error == nil else {
                completion(.failure(.networking))
                self?.log(with: .networking)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.response))
                self?.log(with: .response)
                return
            }

            guard let data else {
                completion(.failure(.invalidData))
                self?.log(with: .invalidData)
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
    
    private func log(with error: NetworkError) {
        os_log(.error, log: .network, "%@", error.localizedDescription)
    }
    
}
