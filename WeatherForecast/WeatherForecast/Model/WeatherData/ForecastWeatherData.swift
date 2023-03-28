//
//  ForecastWeatherData.swift
//  WeatherForecast
//
//  Created by Blu on 2023/03/28.
//

import Foundation

struct ForecastWeatherData {
    let dataTime: Date
    let temperature, minimumTemperature, maximumTemperature: Double
    let icon: String
}
