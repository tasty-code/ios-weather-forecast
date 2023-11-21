//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let networkManager: NetworkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.fetchCurrentWeather(latitude: -122.47823364517218, longitude: 37.820072649485134) { CurrentWeather in
//            print(CurrentWeather)
        }
        networkManager.fetchForecastWeather(latitude: -122.47823364517218, longitude: 37.820072649485134) { ForecastWeather in
            print(ForecastWeather?.city)
        }
    }


}

