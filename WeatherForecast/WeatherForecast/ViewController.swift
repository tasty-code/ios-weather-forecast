//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let manager = LocationManager()
    let currentLocationManger = CurrentLocationManager(networkManager: NetworkManager(urlFormatter: WeatherURLFormatter()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manager.manager.requestLocation()
        manager.currentLocationManager = currentLocationManger
        manager.weatherDelgate = self
    }
}

extension ViewController: WeatherUpdateDelegate {
    func fetchWeather() {
        currentLocationManger.sendRequest(path: WeatherURL.current.path) { (result:Result<CurrentWeather, Error>) in
            switch result {
            case .success(let weather):
                print("\(weather)")
            case .failure(let error):
                print("\(error)")
            }
        }
        currentLocationManger.sendRequest(path: WeatherURL.weekly.path) { (result:Result<CurrentWeather, Error>) in
            switch result {
            case .success(let weather):
                print("\(weather)")
            case .failure(let error):
                print("\(error)")
            } 
        }
    }
}
