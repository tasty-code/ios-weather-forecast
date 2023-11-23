//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherViewController: UIViewController {
    private let networkManager = WeatherNetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.loadData(type: WeatherType.forecast)
    }
}
