//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/20/23.
//

import Foundation

final class NetworkManager {
    enum NetworkingError: Error, CustomDebugStringConvertible {
        case unknown
        case taskingError
        case badClientRequest(statusCode: Int)
        case badServerResponse(statusCode: Int)
        case corruptedData
        
        var debugDescription: String {
            switch self {
            case .unknown: "알 수 없는 에러입니다."
            case .taskingError: "DataTask 작업 중 에러가 발생했습니다."
            case .badClientRequest(let statusCode): "클라이언트 측 에러입니다. Code: \(statusCode)"
            case .badServerResponse(let statusCode): "서버 측 에러입니다. Code: \(statusCode)"
            case .corruptedData: "손상된 데이터입니다."
            }
        }
    }
    
    static func makeURL(_ components: URLComponents?, queries: [URLQueryItem]) -> URL? {
        var components = components
        components?.queryItems = queries
        return components?.url
    }
    
    static func downloadData(url: URL, _ completionHandler: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completionHandler(.failure(NetworkingError.taskingError))
            }
            
            guard let response = response as? HTTPURLResponse else { return completionHandler(.failure(NetworkingError.unknown)) }
            
            guard (200..<300).contains(response.statusCode) else {
                return completionHandler(.failure(NetworkingError.badServerResponse(statusCode: response.statusCode)))
            }
            
            guard let data = data else {
                return completionHandler(.failure(NetworkingError.corruptedData))
            }
            
            completionHandler(.success(data))
        }.resume()
    }
}
