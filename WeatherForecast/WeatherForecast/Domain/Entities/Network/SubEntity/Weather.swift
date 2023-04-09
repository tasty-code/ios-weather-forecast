//
//  Weather.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/14.
//

import Foundation

struct Weather: Decodable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String
}
