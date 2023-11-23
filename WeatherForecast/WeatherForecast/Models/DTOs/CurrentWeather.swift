//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

struct CurrentWeather: Decodable {
    let dateTime: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let snow, rain: Moisture?
    let visibility: Int
    let sys: SystemData
    let coord: Coordinate
    let base: String
    let timezone, id: Int
    let name: String
    let cod: Int

    enum CodingKeys: String, CodingKey {
        case main, weather, clouds, wind, rain, snow, visibility, sys, coord, base, timezone, id, name, cod
        case dateTime = "dt"
    }
}
