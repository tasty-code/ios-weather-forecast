//
//  ForecastData.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/20.
//

import Foundation

struct ForecastData: Decodable {
    let timestamp: Int
    let weatherDetail: WeatherDetail
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int?
    let probabilityOfPrecipitation: Double?
    let rain: Rain?
    let snow: Snow?
    let dateString: String

    enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case weatherDetail = "main"
        case weather, clouds, wind, visibility, rain, snow
        case probabilityOfPrecipitation = "pop"
        case dateString = "dt_txt"
    }
}
