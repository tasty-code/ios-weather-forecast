//
//  MyCoreLocationManager.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/03.
//

import Foundation

import CoreLocation

// MARK: - Protocols

protocol LocationUpdateProtocol: AnyObject {
    func locationDidUpdateToLocation(location: CLLocation)
}

final class MyCoreLocationManager: NSObject {
    
    static let shared = MyCoreLocationManager()
    
    private let locationManager = CLLocationManager()
    
    weak var delegate: LocationUpdateProtocol?
    
    override init() {
        super.init()
        self.setUpLocationManager()
    }
}

// MARK: - Methods

extension MyCoreLocationManager {
    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension MyCoreLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        delegate?.locationDidUpdateToLocation(location: currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
}
