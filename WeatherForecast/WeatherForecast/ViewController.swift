//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.callAPI()
    }
}

