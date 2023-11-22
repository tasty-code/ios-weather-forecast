//
//  SystemData.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

struct SystemData: Decodable {
    let type, id: Int?
    let country, pod: String?
    let sunrise, sunset: Int?
}
