//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    private let networkManager = NetworkManager()
    private let locationManager = LocationManager()
    private lazy var weatherManager = WeatherDataManager(networkManager: networkManager,
                                                         currentLocationManager: CurrentLocationManager())
    private lazy var weatherImageManager = WeatherImageManager(networkManager: networkManager)
    
    private var mainWeatherView: MainWeatherView!
    
    override func loadView() {
        super.loadView()
        mainWeatherView = MainWeatherView(weatherDataDelegate: weatherManager, imageDelegate: weatherImageManager, locationDelegate: locationManager)
        weatherManager.delegate = mainWeatherView
        view = mainWeatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.manager.requestLocation()
        locationManager.currentLocationManager = weatherManager.currentLocationManager
        locationManager.weatherDelgate = weatherManager
    }
}
