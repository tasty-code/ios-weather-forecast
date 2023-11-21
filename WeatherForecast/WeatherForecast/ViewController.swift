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
                    print(self.fiveWeather)
                }
            case .failure(_ ):
                print("error")
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
}

