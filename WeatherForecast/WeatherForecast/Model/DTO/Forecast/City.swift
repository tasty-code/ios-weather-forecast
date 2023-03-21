//
//  City.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/20.
//

import Foundation

struct City: Decodable {
    let id: Int
    let name: String
    let coordinate: Coordinate
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int

    enum CodingKeys: String, CodingKey {
        case id, name, country, population, timezone, sunrise, sunset
        case coordinate = "coord"
    }
}
