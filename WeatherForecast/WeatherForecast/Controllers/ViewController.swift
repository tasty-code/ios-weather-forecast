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
    func update(with data: LocationData) {
        printLocationData(data)
        let weatherRequest = WeatherRequest(latitude: data.latitude,
                                            longitude: data.longitude,
                                            weatherType: .current)
        networkManager.fetchData(for: weatherRequest) { (result: Result<Current, Error>) in
            switch result {
            case .success(let weather):
                print(weather)
                print("")
            case .failure(let error):
                print(error)
            }
        }
        
        let forecastRequest = WeatherRequest(latitude: data.latitude,
                                            longitude: data.longitude,
                                            weatherType: .forecast)
        networkManager.fetchData(for: forecastRequest) { (result: Result<Forecast, Error>) in
            switch result {
            case .success(let weather):
                print(weather)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController {
    private func printLocationData(_ data: LocationData) {
        print("위도: \(data.latitude) 경도: \(data.longitude) 주소: \(data.address) \n")
    }
}
