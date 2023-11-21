//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    private let networkManager = NetworkManager(lat: 37.532600, lon: 127.024612)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.startLoad()
    }
}
