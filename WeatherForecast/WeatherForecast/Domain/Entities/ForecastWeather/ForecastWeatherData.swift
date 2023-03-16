//
//  ForecastWeatherData.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/03/14.
//

import Foundation

struct ForecastWeatherData {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let rain: Rain
    let sys: WeatherSystem
    let date: String

    enum CodingKeys: String, CodingKey {
        case date = "dt_txt"
    }
}
