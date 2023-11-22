//
//  ServiceManager.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

final class ServiceManager {
    static let shared = ServiceManager()
    
    private init() {}
    
    private enum ServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    public func execute<T: Decodable>(
        _ request: URLRequest?,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void) {
            
            guard let urlRequest = request else {
                completion(.failure(ServiceError.failedToCreateRequest))
                return
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, _ , error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? ServiceError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(type.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
}
