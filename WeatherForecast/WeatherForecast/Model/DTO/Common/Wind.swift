//
//  Wind.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/20.
//

import Foundation

struct Wind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double
}
