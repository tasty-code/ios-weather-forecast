//
//  WeatherClient.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 2023/11/21.
//

import Foundation
import Combine

struct WeatherClient {
    func publishCurrentWeather(_ publisher: AnyPublisher<(Data, HTTPURLResponse), Error>) -> AnyPublisher<CurrentWeather, Error>  {
        return publisher.tryMap { (data, httpResponse) in
            guard (200..<300).contains(httpResponse.statusCode)
            else {
                fatalError("status code 오류")
            }
            
            if data.count <= 0 {
                fatalError("data가 없음")
            }
            
            return data
        }
        .decode(type: CurrentWeather.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
}
