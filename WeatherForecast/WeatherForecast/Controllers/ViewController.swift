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

extension ViewController: LocationManagerDelegate {
    func update(with info: LocationData) {
        let weatherRequest = WeatherRequest(latitude: info.latitude,
                                            longitude: info.longitude,
                                            weatherType: .current)
        networkManager.fetchData(for: weatherRequest) { (result: Result<Current, Error>) in
            switch result {
            case .success(let weather):
                print(weather)
            case .failure(let error):
                print(error)
            }
        }
    }
}
