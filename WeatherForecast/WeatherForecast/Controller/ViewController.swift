//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let repository = OpenWeatherRepository()
        
        repository.fetchWeather(lattitude: 44.34, longitude: 10.99)
//        print(Bundle.main.apiKey)
    }
}

