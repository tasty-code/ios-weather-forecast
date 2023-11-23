//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 김진웅 on 11/20/23.
//

import Foundation

final class NetworkManager {
    
    func fetchData<T: Decodable>(for request: APIRequest?,
                                    completion: @escaping (Result<T, Error>)-> Void) {
        
        guard let request = request else {
            completion(.failure(NetworkError.invalidAPIKey))
            return
        }
        
        guard let url = makeURL(for: request) else {
            completion(.failure(NetworkError.invalidURLError))
            return
        }
        print(url)
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.unknownError(error)))
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
            
            do {
                let weather = try JSONDecoder().decode(T.self, from: data)
                completion(.success(weather))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
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
