//
//  WeatherHTTPClient.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 2023/11/22.
//

import Foundation
import UIKit
import Combine

struct WeatherHTTPClient {
    static private func publishRequest(from request: URLRequest) -> AnyPublisher<Data, Error> {
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
            .eraseToAnyPublisher()
    }
    
    static func publishForecast<T: Decodable>(from request: URLRequest, forecastType: T.Type) -> AnyPublisher<T, Error> {
        return publishRequest(from: request)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        }
    
    static func publishWeatherIcon(from request: URLRequest) -> AnyPublisher<UIImage?, Error> {
        return publishRequest(from: request)
            .tryMap {
                UIImage(data: $0)
            }
            .eraseToAnyPublisher()
    }
    
    static func updateWeatherIcon(from request: URLRequest, valueHandler: @escaping (UIImage) -> Void) -> AnyCancellable {
        return Self.publishWeatherIcon(from: request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    debugPrint(error)
                }
            } receiveValue: { uiImage in
                guard let uiImage = uiImage else { return }
                valueHandler(uiImage)
            }
    }
}
