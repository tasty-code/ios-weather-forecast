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
        coreLocationManger.desiredAccuracy = kCLLocationAccuracyKilometer
        coreLocationManger.requestWhenInUseAuthorization()
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let recentLocation = manager.location else {
            return
        }
        
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(recentLocation, preferredLocale: locale) { placemark, error in
            guard error == nil else {
                return
            }
            
            guard let firstLocation = placemark?.last else { return }
            print(firstLocation)
            
        }
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
            manager.requestWhenInUseAuthorization()
        default:
            return
        }
    }
}
