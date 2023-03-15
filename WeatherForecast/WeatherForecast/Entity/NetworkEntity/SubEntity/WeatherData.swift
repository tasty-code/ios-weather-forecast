//
//  WeatherData.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/03/15.
//

import Foundation

struct WeatherData {
    let TimeOfDataCalculation: Double
    let main: Main
    let weather: [Weather]
    let clounds: Clouds
    let wind: Wind
    let date: Date

    enum CodingKeys: String, CodingKey {
        case TimeOfDataCalculation = "dt"
        case date = "dt_txt"
    }
}
