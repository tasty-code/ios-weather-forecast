//
//  Main.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

struct Main: Decodable {
    let temp, tempMin, tempMax: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}
