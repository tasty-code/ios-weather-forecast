//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkService().getWeather(informationType: .weather, latitude: 37.6, longitude: 127.3) { (result: Result<CurrentWeather, NetworkError>) in
            switch result {
            case.success(_ ):
                print("성공")
            case.failure(_ ):
                print("error")
            }
        }
        NetworkService().getWeather(informationType: .forecast, latitude: 37.6, longitude: 127.3) { (result: Result<ForecastWeather, NetworkError>) in
            switch result {
            case.success(_ ):
                print("성공")
            case.failure(_ ):
                print("error")
            }
            
        }
    }


}

