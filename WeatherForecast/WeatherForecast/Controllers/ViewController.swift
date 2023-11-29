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

extension ViewController: LocationUpdateDelegate {
    func updateWeather(with data: LocationData) {
        let weatherRequest = WeatherRequest(latitude: data.latitude,
                                            longitude: data.longitude,
                                            weatherType: .current)
        networkManager.fetchData(for: weatherRequest) { (result: Result<Current, Error>) in
            switch result {
            case .success(_): break
            case .failure(_): break
            }
        }
        
        let forecastRequest = WeatherRequest(latitude: data.latitude,
                                             longitude: data.longitude,
                                             weatherType: .forecast)
        networkManager.fetchData(for: forecastRequest) { (result: Result<Forecast, Error>) in
            switch result {
            case .success(_): break
            case .failure(_): break
            }
        }
    }
    
    func notifyLocationErrorAlert() {
        let alert = UIAlertController(title: "위치 정보 오류", message: "사용자의 위치 정보를 가져 올 수 없습니다", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
