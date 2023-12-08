//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    let locationManager = LocationManager()
    let currentLocationManger = CurrentLocationManager(networkManager: NetworkManager(urlFormatter: WeatherURLFormatter()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.manager.requestLocation()
        locationManager.currentLocationManager = currentLocationManger
        locationManager.weatherDelgate = self
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
        currentLocationManger.sendRequest(path: WeatherURL.weekly.path) { (result:Result<WeeklyWeather, Error>) in
            switch result {
            case .success(let weather):
                self.weeklyWeatherData = weather
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                print(weather)
            case .failure(let error):
                print("\(error)")
            } 
        }
    }
}


