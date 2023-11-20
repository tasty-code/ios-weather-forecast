//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

struct CurrentWeather: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let snow: Snow
    let rain: Rain
    let visibility: Int
    let sys: Sys
    let coord: Coord
    let base: String
    let timezone, id: Int
    let name: String
    let cod: Int
}

