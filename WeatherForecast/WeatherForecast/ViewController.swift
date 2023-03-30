//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let networkManager = NetworkManager()
    let locationManager = LocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        networkManager.callAPI()
        locationManager.startUpdatingLocation()
    }
}

