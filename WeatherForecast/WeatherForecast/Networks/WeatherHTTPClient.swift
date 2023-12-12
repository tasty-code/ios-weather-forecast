//
//  WeatherHTTPClient.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 2023/11/22.
//

import Foundation
import Combine

struct WeatherHTTPClient {
    static func publishForecast<T: Decodable>(from request: URLRequest, forecastType: T.Type) -> AnyPublisher<T, Error>  {
        return URLSession.shared.publisher(request: request)
            .tryMap { (data, httpResponse) in
                guard (200..<300).contains(httpResponse.statusCode)
                else {
                    throw StatusCodeError.httpError(httpResponse.statusCode)
                }
                
                if data.count <= 0 {
                    throw URLError(.zeroByteResource)
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        }
}
