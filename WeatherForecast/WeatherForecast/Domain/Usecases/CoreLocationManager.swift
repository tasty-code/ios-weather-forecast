//
//  CoreLocationManager.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/03.
//

import Foundation

import CoreLocation

// MARK: - Protocols

protocol LocationUpdateDelegate: AnyObject {
    func locationDidUpdateToLocation(location: Location)
}

final class CoreLocationManager: NSObject {
        
    private let locationManager = CLLocationManager()
    
    weak var delegate: LocationUpdateDelegate?
    
    override init() {
        super.init()
        self.setUpLocationManager()
    }
}

// MARK: - Methods

extension CoreLocationManager {
    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension CoreLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        let location = Location(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        delegate?.locationDidUpdateToLocation(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
}
