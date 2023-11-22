//
//  URLSession.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 2023/11/21.
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
                guard let httpResponse = response as? HTTPURLResponse
                else {
                    throw URLError(.badServerResponse)
                }
                return (data, httpResponse)
            }
            .eraseToAnyPublisher()
    }
}
