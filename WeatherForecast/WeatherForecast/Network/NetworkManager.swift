//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

final class NetworkManager {
    private enum NetworkError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    public func execute<T: Decodable>(
        _ request: URLRequest?,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void) {
            
            
            guard let urlRequest = request else {
                completion(.failure(NetworkError.failedToCreateRequest))
                return
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, _ , error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? NetworkError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(type.self, from: data)
                    print(data)
                    
                    completion(.success(result))
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
}
