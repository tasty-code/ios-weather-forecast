//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    private let networkModel = NetworkModel()
    private lazy var network = WeatherAPIManager(networkModel: networkModel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coordinate = Coordinate(longitude: 126, latitude: 37)
        network.fetchWeatherInformation(of: .fiveDaysForecast, in: coordinate)
    }


}

