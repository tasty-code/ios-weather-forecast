//
//  Weather.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/20.
//

import Foundation

struct Weather: Decodable {
    let id: Int
    let main, description, icon: String
}
