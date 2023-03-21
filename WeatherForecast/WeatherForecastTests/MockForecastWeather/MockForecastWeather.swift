//
//  MockForecastWeather.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/03/14.
//

import Foundation

struct MockForecastWeather {
    let city: City
    let time: Int
    let data: [MockForecastWeatherData]
}
