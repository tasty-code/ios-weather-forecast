//
//  WeatherForecast.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/20/23.
//

import Foundation

struct WeatherForecast: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [WeatherList]
    let rain: WeatherCommonInformation.Rain?
    let snow: WeatherCommonInformation.Snow?
}

// MARK: - WeatherList

extension WeatherForecast {
    struct WeatherList: Decodable {
        let dt: Int
        let visibility: Int
        let pop: Double
        let dtTxt: String
        
        let main: WeatherCommonInformation.Main
        let weather: [WeatherCommonInformation.Weather]
        let clouds: WeatherCommonInformation.Clouds
        let wind: WeatherCommonInformation.Wind
        let sys: Sys
        
        private enum CodingKeys: String, CodingKey {
            case dtTxt = "dt_txt"
            case dt, visibility, pop, main, weather, clouds, wind, sys
        }
        
        struct Sys: Decodable {
            let pod: String
        }
    }
}
