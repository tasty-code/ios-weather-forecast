//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 김진웅 on 11/20/23.
//

import Foundation

final class NetworkManager {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchData(for request: APIRequest?,
                                 completion: @escaping (Result<Data, NetworkError>)-> Void) {
        guard let request = request else {
            completion(.failure(NetworkError.invalidAPIKey))
            return
        }
        
        guard let url = makeURL(for: request) else {
            completion(.failure(NetworkError.invalidURLError))
            return
        }
        
        let dataTask: URLSessionDataTaskProtocol = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.unknownError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            guard (200 ..< 299) ~= response.statusCode else {
                completion(.failure(NetworkError.responseError(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noDataError))
                return
            }
            completion(.success(data))
        }
        dataTask.resume()
    }
    
    private func makeURL(for request: APIRequest) -> URL? {
        var components = URLComponents()
        components.scheme = request.scheme
        components.host = request.host
        components.path = request.path
        components.queryItems = request.parameters?.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        return components.url
    }
}
