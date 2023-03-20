//
//  Forecast.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/13.
//

import Foundation

struct Forecast: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [List]
    let city: City
}
