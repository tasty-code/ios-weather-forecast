//
//  HTTPClient.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 2023/11/22.
//

import Foundation
import Combine

protocol HTTPClient {
    func publisher(request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error>
}

extension URLSession: HTTPClient {
    func publisher(request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        return dataTaskPublisher(for: request)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.cannotParseResponse)
                }
                return (data, httpResponse)
            }
            .eraseToAnyPublisher()
            
    }
}
