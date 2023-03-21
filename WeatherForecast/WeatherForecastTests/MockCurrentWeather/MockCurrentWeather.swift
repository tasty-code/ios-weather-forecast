//
//  MockCurrentWeather.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/14.
//

import Foundation

struct MockCurrentWeather {
    let city: City
    let time: Double
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let weather: [Weather]
}
