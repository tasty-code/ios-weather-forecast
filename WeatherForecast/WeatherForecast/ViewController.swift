//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
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
    }
}

