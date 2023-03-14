//
//  ForecastWeatherData.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/03/14.
//

import Foundation

struct ForecastWeatherData {
    var dt: Int
    var main: Main
    var weather: [Weather]
    var clouds: Clouds
    var wind: Wind
    var rain: Rain
    var sys: WeatherSystem
    var date: String

    enum CodingKeys: String, CodingKey {
        case date = "dt_txt"
    }
}
