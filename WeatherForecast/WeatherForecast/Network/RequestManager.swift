//
//  ServiceManager.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

final class RequestManager {
    private let endpoint: Endpoint
    private let queryParameters: [URLQueryItem]
    
    private var urlString: String {
        var url: String = Environment.baseURL
        url += endpoint.rawValue
        
        if !queryParameters.isEmpty {
            url += "?"
            
            let queries: String = queryParameters.compactMap {
                guard let value = $0.value else { return "" }
                return "\($0.name)=\(value)"
            }.joined(separator: "&")
            
            url += queries
        }
        print("🔥",url)
        return url
    }
    
    // MARK: - Public
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public let httpMethod = "GET"
    
    // MARK: - Initializer
    init(endpoint: Endpoint, queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.queryParameters = queryParameters
    }
}

