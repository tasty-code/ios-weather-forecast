//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    var weather: CurrentWeatherDTO?
    var fiveWeather: FiveDaysWeatherDTO?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CurrentWeatherManager().fetchWeather(completion: { result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    self.weather = weatherResponse
                    guard let weather = self.weather else {
                        return
                    }
                    print(weather)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
}

