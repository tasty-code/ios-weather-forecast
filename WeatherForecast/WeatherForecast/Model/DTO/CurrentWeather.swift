//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Mason Kim on 2023/03/13.
//

import Foundation

// MARK: - CurrentWeather
struct CurrentWeather: Decodable {
    let coord: Coordinate
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let timezone, id: Int
    let name: String
    let cod: Int
}
