//
//  Coord.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Rain
struct Rain: Codable {
    let the1H, the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
        case the3H = "3h"
    }
}

// MARK: - Snow
struct Snow: Codable {
    let the1H, the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
        case the3H = "3h"
    }
}

