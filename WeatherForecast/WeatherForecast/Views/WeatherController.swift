//
//  WeatherController.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/03/24.
//

import UIKit

struct WeatherController {
    
    struct CurrentWeather {
        let image: UIImage
        let address: String
        let temperatures: Temperature
    }
    
    struct FiveDaysForecast {
        let image: UIImage
        let date: String
        let temperature: Double
    }
}
