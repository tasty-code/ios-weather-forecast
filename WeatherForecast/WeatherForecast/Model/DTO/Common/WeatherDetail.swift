//
//  WeatherDetail.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/20.
//

import Foundation

struct WeatherDetail: Decodable {
    let temperature, feelsLike, minimumTemperature,  maximumTemperature: Double
    let pressure, humidity: Int
    let seaPressureLevel, groundPressureLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
        case pressure, humidity
        case seaPressureLevel = "sea_level"
        case groundPressureLevel = "grnd_level"
    }
}
