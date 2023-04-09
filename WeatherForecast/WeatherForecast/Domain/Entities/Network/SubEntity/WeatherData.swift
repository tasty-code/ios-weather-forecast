//
//  WeatherData.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/03/15.
//

import Foundation

struct WeatherData: Decodable {
    let timeOfDataCalculation: Double
    let main: Main
    let weather: [Weather]
    let clouds: Clouds?
    let wind: Wind?
    let date: String

    enum CodingKeys: String, CodingKey {
        case timeOfDataCalculation = "dt"
        case main
        case weather
        case clouds
        case wind
        case date = "dt_txt"
    }
}
