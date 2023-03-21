//
//  Snow.swift
//  WeatherForecast
//
//  Created by Mason Kim on 2023/03/20.
//

import Foundation

struct Snow: Decodable {
    let volumeForLast3Hours: Double?

    enum CodingKeys: String, CodingKey {
        case volumeForLast3Hours = "3h"
    }
}
