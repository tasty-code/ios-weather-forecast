//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    private let locationManager: LocationManager = LocationManager()
    private let networkManager: NetworkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
}

extension ViewController: UpdatedLocationDelegate {
    func update(with data: LocationData) {
        let weatherRequest = WeatherRequest(latitude: data.latitude,
                                            longitude: data.longitude,
                                            weatherType: .current)
        networkManager.fetchData(for: weatherRequest) { (result: Result<Current, Error>) in
            switch result {
            case .success(_):
              break
            case .failure(_):
              break
            }
        }
        
        let forecastRequest = WeatherRequest(latitude: data.latitude,
                                            longitude: data.longitude,
                                            weatherType: .forecast)
        networkManager.fetchData(for: forecastRequest) { (result: Result<Forecast, Error>) in
            switch result {
            case .success(_):
              break
            case .failure(_):
                break
            }
        }
    }
}
