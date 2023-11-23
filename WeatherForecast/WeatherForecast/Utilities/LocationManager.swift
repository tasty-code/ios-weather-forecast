//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/20/23.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private let locationManager: CLLocationManager = CLLocationManager()
    private var location: CLLocation?
    
    private override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func fetchCurrentLocatedCoordinates() -> CLLocationCoordinate2D? {
        location?.coordinate
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
}
