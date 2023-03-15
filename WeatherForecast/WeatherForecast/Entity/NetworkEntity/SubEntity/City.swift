//
//  City.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/03/15.
//

import Foundation

struct City: Decodable {
    let id: Int
    let name: String
    let coordinator: Coordinate
    let country: String
    let sunrise: Double
    let sunset: Double

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case coordinator = "coord"
        case country
        case sunrise
        case sunset
    }
}
