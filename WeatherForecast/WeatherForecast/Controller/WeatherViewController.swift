//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation


// TODO: 버튼 두 개 만들어서 하나는 예보, 하나는 현재 날씨 불러오도록 구현

final class WeatherViewController: UIViewController {
    private let networkManager = WeatherNetworkManager()
    private let locationDataManager = LocationDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationDataManager.locationDelegate = self
    }
}

// MARK: - LocationDataManagerDelegate

extension WeatherViewController: LocationDataManagerDelegate {
    func location(_ manager: LocationDataManager, didLoad coordinate: CLLocationCoordinate2D) {
        networkManager.loadWeatherData(type: WeatherType.weatherToday, coord: coordinate)
    }
}
