//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/20/23.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(locationManager: LocationManager, location: CLLocation)
}

final class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private let locationManager: CLLocationManager = CLLocationManager()
    private var location: CLLocation?
    private weak var delegate: LocationManagerDelegate?
    
    private override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    func setDelegate(instance: LocationManagerDelegate) {
        self.delegate = instance
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        delegate?.didUpdateLocation(locationManager: self, location: location)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined, .denied, .restricted:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
