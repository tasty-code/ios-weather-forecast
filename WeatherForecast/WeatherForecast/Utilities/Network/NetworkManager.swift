//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/20/23.
//

import Foundation

protocol NetworkDownloadable {
    func downloadData<Builder: NetworkBuilderProtocol>(_ builder: Builder, completionHandler: @escaping (Result<Builder.Response, Error>) -> Void)
}

enum NetworkingError: Error, CustomDebugStringConvertible {
    case unknown
    case notFoundBaseURL
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
        case .notFoundBaseURL: "요청한 URL을 찾을 수 없습니다."
        }
    }
}

final class NetworkManager: NetworkDownloadable {
    private let urlSession: URLSession
    private let baseURLResolver: BaseURLResolvable
    
    init(baseURLResolver: BaseURLResolvable) {
        self.urlSession = URLSession.shared
        self.baseURLResolver = baseURLResolver
    }
    
    func downloadData<Builder: NetworkBuilderProtocol>(_ builder: Builder, completionHandler: @escaping (Result<Builder.Response, Error>) -> Void) {
        guard let request = makeURLRequest(builder) else {
            return completionHandler(.failure(NetworkingError.notFoundBaseURL))
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completionHandler(.failure(NetworkingError.taskingError))
            }
            
            guard let response = response as? HTTPURLResponse else { return completionHandler(.failure(NetworkingError.unknown)) }
            
            guard (200..<300).contains(response.statusCode) else {
                return completionHandler(.failure(NetworkingError.badServerResponse(statusCode: response.statusCode)))
            }
            
            guard let data = data as? Builder.Response else {
                return completionHandler(.failure(NetworkingError.corruptedData))
            }
            
            completionHandler(.success(data))
        }.resume()
    }
}

// MARK: Private Methods
extension NetworkManager {
    private func makeURLRequest<Builder: NetworkBuilderProtocol>(_ builder: Builder) -> URLRequest? {
        guard let baseURL = baseURLResolver.resolve(for: .openWeatherMap) else { return nil }
        let url = baseURL.appendingPathComponent(builder.path)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        builder.parameters.forEach { urlQueryItem in
            request.setValue(urlQueryItem.value, forHTTPHeaderField: urlQueryItem.name)
        }
        
        return request
    }
}
