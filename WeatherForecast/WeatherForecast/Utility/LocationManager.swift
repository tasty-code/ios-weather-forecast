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
    private(set) var coordinates: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        self.manager = CLLocationManager()
        self.manager.delegate = self
//        self.manager.startUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("aaaaaa")
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            coordinates = CLLocationCoordinate2D(latitude: 37.5336584, longitude: 126.9775707)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        coordinates = location.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
