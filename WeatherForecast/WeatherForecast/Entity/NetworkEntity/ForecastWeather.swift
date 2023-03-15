//
//  ForecastWeather.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/03/14.
//

import Foundation

struct ForecastWeather: Decodable {
    let list: [WeatherData]
    let city: City

    enum CodingKeys: String, CodingKey {
        case list
        case city
    }
}
