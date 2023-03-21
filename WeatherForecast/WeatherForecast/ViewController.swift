//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    private let repository = Repository()
    let location = CLLocationCoordinate2D(latitude: 44.34, longitude: 10.99)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try repository.loadData(type: .currentWeather, location: location)
            try repository.loadData(type: .forecastWeather, location: location)
        } catch {
            print(error.localizedDescription)
        }
    }
}
