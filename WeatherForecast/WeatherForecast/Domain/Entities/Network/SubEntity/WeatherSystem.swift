//
//  WeatherSystem.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/03/14.
//

import Foundation

struct WeatherSystem: Decodable {
    let pod : String?
    let country: String?
    let sunrise: Double?
    let sunset: Double?
}
