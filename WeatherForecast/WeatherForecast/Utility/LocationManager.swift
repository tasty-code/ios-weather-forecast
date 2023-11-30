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
    private(set) var location: CurrentLocationInfo!
    
    override init() {
        super.init()
        self.manager = CLLocationManager()
        self.manager.delegate = self
        self.location = CurrentLocationInfo()
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
            location.coordinates = CLLocationCoordinate2D(latitude: 37.5336584, longitude: 126.9775707)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location.coordinates = location.coordinate
    
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let placemark = placemarks?.last else { return }
            self?.location.city = placemark.locality
            self?.location.district = placemark.subLocality
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
