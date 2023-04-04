//
//  WindDTO.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/04.
//

import Foundation

struct WindDTO: Decodable {
    let speed, gust: Double?
    let deg: Int?
}
