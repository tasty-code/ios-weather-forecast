//
//  WeatherForecast.swift
//  WeatherForecast
//
//  Created by 김준성 on 11/20/23.
//

import Foundation

struct FiveDayWeatherForecast: Decodable {
    let status: String
    let message: Int
    let count: Int
    let list: [Forecast]
    let city: City
    
    enum CodingKeys: String, CodingKey {
        case status = "cod"
        case message
        case count = "cnt"
        case list
        case city
    }
}
