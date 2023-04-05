//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    let networkManager = NetworkManager()
    let locationManager = LocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        setUp()
    }
    
    private func setUp() {
        locationManager.startUpdatingLocation()
    }
}

extension ViewController: LocationManagerDelegate {
    func locationManager(_ manager: LocationManager, didUpdateLocation location: CLLocation) {
        networkManager.updateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        networkManager.callAPI()
    }
}
