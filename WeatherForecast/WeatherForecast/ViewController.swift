//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let network = NetworkManager()
        let coordinate = Coordinate(longitude: 30, latitude: 30)
        network.fetchWeatherInformation(of: .currentWeather, in: coordinate)
    }


}

