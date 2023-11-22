//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    private let networkManager = NetworkManager()
    private let apiClient = ApiClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataType = WeatherType.forecast
        networkManager.loadData(apiClient: apiClient, type: dataType)
    }
}
