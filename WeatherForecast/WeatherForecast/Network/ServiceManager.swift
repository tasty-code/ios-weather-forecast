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
    

    public func execute<T: Codable>(
        _ request: RequestManager,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void) {

            guard let urlRequest = self.request(from: request) else {
//                completion(.failure(RMServiceError.failedToCreateRequest))
                return
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) {[weak self] data, _ , error in
                guard let data = data, error == nil else {
//                    completion(.failure(error ?? RMServiceError.failedToGetData))
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
    // MARK: - Private
    private func request(from request: RequestManager) -> URLRequest? {
        guard let url = request.url else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = request.httpMethod
        
        return request
    }
    
    
}

