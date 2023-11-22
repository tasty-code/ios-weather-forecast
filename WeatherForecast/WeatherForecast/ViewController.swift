//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let weatherDataService = WeatherForecastDataService<WeatherModel>(networkManager: NetworkManager.shared)
        let forecastDataService = WeatherForecastDataService<ForecastModel>(networkManager: NetworkManager.shared)
        
        weatherDataService.fetchData(.weather)
        forecastDataService.fetchData(.forecast)
        
        sleep(3)
        
        if let weather = weatherDataService.foo(),
           let forecast = forecastDataService.foo() {
            print(weather)
            print(forecast)
        }
    }
}

