//
//  WeatherForecast.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/20/23.
//

import Foundation

struct WeatherForecast {
    let cod: Int
    let message: Int
    let cnt: Int
    let list: [WeatherList]
    
}

// MARK: - WeatherList

extension WeatherForecast {
    struct WeatherList {
        let dt: Int
        let visibility: Int
        let pop: Double
        let dtTxt: String
        
        let main: WeatherCommonInformation.Main
        let weather: [WeatherCommonInformation.Weather]
        let clouds: WeatherCommonInformation.Clouds
        let wind: WeatherCommonInformation.Wind
        let sys: Sys
        
        struct Sys: Decodable {
            let pod: String
        }
    }
}
