//
//  Wind.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/20.
//

import Foundation

struct Wind: Decodable {
    let speed: Double
    let windDirectionDegrees: Int?
    let gust: Double?

    enum CodingKeys: String, CodingKey {
        case windDirectionDegrees = "deg"
        case speed, gust
    }
}

