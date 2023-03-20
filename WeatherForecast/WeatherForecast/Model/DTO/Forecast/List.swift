//
//  List.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/20.
//

import Foundation

struct List: Decodable {
    let dt: Int
    let main: MainData
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let dtTxt: String
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain
        case dtTxt = "dt_txt"
    }
}
