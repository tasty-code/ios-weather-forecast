//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        APIService.shared.fetchFiveDayWeather(lat: 37.53, lon: 126.96) { result in
                    switch result {
                    case .success(let currentWeather):
                        print(currentWeather)
                    case .failure(let error):
                        print(error.errorDescription as Any)
                    }
                }
    }
}
