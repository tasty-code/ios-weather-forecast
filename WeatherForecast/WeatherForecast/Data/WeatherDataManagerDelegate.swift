//
//  WeatherDataManagerDelegate.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/8/23.
//

import Foundation
import UIKit

protocol WeatherDataManagerDelegate: AnyObject {
    func updateTodayWeatherView(_ manager: WeatherDataManager, with today: WeatherToday)
    func updateForecastWeatherView(_ manager: WeatherDataManager, with forecast: WeatherForecast)
}
