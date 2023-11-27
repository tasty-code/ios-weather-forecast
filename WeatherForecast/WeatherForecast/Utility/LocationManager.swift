//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by BOMBSGIE on 2023/11/27.
//

import UIKit
import CoreLocation

final class LocationManager: NSObject {
    var manager: CLLocationManager!
    var coordinates: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        self.manager = CLLocationManager()
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            self.coordinates = manager.location?.coordinate
        case .notDetermined, .restricted:
            manager.requestWhenInUseAuthorization()
        case .denied:
            guard CLLocationManager.locationServicesEnabled() else {
                return
            }
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
