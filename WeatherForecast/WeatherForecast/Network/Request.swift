//
//  Request.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

protocol Request {
    var endpoint: Endpoint { get set }
    var queryParameters: [URLQueryItem] { get set }
    var httpMethod: HttpMethod? { get set }
    
    func makeURLrequest() -> URLRequest?
}

extension Request {
    func makeURLrequest() -> URLRequest? {
        guard let url = self.url else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = request.httpMethod
        return request
    }
    
    var urlString: String {
        var url: String = Environment.baseURL
        url += self.endpoint.rawValue
        
        if !queryParameters.isEmpty {
            url += "?"
            
            let queries: String = queryParameters.compactMap {
                guard let value = $0.value else { return "" }
                return "\($0.name)=\(value)"
            }.joined(separator: "&")
            
            url += queries
        }
        
        return url
    }
    
    var url: URL? {
        let url = URL(string: urlString)
        return url
    }
}

struct GetRequest: Request {
    var endpoint: Endpoint
    var queryParameters: [URLQueryItem]
    var httpMethod: HttpMethod? = .GET
    
    // MARK: - Initializer
    init(endpoint: Endpoint, queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.queryParameters = queryParameters
    }
}

