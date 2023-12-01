//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by BOMBSGIE on 2023/11/27.
//

import UIKit
import CoreLocation

final class LocationManager: NSObject {
    private(set) var manager: CLLocationManager!
    var currentLocationManager: CurrentLocationManagable?
    
    override init() {
        super.init()
        self.manager = CLLocationManager()
        self.manager.delegate = self
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let placemark = placemarks?.last else { return }
            self?.currentLocationManager?.updateLocationInfo(with: placemark)
            
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
