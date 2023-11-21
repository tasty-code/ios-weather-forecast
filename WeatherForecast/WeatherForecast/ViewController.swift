//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkService().getForecastWeather { result in
                   switch result {
                   case .success(let weatherResponse):
                       DispatchQueue.main.async {
            
                       }
                   case .failure(_ ):
                       print("error")
                   }
               }
    }


}

