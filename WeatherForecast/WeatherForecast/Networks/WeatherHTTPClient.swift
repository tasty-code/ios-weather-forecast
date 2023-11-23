//
//  WeatherHTTPClient.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 2023/11/22.
//

import Foundation
import Combine

struct WeatherHTTPClient {
    func publishCurrentWeather(_ publisher: AnyPublisher<(Data, HTTPURLResponse), Error>) -> AnyPublisher<CurrentWeather, Error>  {
            return publisher.tryMap { (data, httpResponse) in
                guard (200..<300).contains(httpResponse.statusCode)
                else {
                    throw StatusCodeError.httpError(httpResponse.statusCode)
                }
                
                if data.count <= 0 {
                    throw URLError(.zeroByteResource)
                }
                
                return data
            }
            .decode(type: CurrentWeather.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        }
}
