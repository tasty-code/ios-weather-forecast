//
//  WeatherForecast - WeatherViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private let networkModel = NetworkModel()
    private lazy var network = WeatherAPIManager(networkModel: networkModel)

    private let locationDelegate = LocationManagerDelegate()
    lazy var coreLocationManger: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreLocationManger.delegate = locationDelegate
        network.fetchWeatherInformation(of: .currentWeather, in: Coordinate(longitude: 126.96368972, latitude: 37.53361968))
        
//        126.96368972
//        37.53361968
    }
}

