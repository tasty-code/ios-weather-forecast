//
//  CurrentWeatherViewModel.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/31.
//

import UIKit
import CoreLocation

final class CurrentWeatherViewModel {
    
    struct CurrentWeather: Identifiable {
            let id = UUID()
            let image: UIImage?
            let address: String
            let temperatures: Temperature
        }
}

