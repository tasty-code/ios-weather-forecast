//
//  Request.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

protocol Request {
    var endpointType: Endpoint { get set }
    var queryParameters: UrlString? { get set }
    var httpMethod: HttpMethod? { get set }
    
    func makeURLrequest() -> URLRequest?
}

extension Request {
    var urlString: String {
        var url: String = self.endpointType.baseUrl
        url += self.endpointType.endpoint
        
        guard let queryParameters = self.queryParameters else {
            return url
        }
        
        url += queryParameters.parameter

        return url
    }
    
    var url: URL? {
        let url = URL(string: urlString)
        return url
    }
    
    func makeURLrequest() -> URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = request.httpMethod
        
        return request
    }
}
