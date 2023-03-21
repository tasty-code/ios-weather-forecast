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
    private let coreLocationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreLocationManger.delegate = self
        coreLocationManger.desiredAccuracy = kCLLocationAccuracyReduced
        coreLocationManger.requestWhenInUseAuthorization()
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let coordinate = Coordinate(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
        network.fetchWeatherInformation(of: .fiveDaysForecast, in: coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("ggod")
        case .notDetermined:
            return
        default:
            return
        }
    }
}
