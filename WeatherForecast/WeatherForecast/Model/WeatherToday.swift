//
//  WeatherToday.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/20/23.
//

import Foundation

struct WeatherToday: Decodable {
    let dt: Int
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    let base: String
    let visibility: Int
    
    let weather: [WeatherCommonInformation.Weather]
    let main: WeatherCommonInformation.Main
    let wind: WeatherCommonInformation.Wind
    let clouds: WeatherCommonInformation.Clouds
    let rain: WeatherCommonInformation.Rain?
    let snow: WeatherCommonInformation.Snow?
    let coord: WeatherCommonInformation.Coord
    let sys: Sys
}

// MARK: - Sys

extension WeatherToday {
    struct Sys: Decodable {
        let type: Int?
        let id: Int?
        let country: String
        let sunrise: Int
        let sunset: Int
    }
}

