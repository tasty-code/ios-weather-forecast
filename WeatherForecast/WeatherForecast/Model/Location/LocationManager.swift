//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/03/24.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func locationManager(_ manager: LocationManager, didUpdateLocation location: CLLocation)
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: - Private property
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()

    weak var delegate: LocationManagerDelegate?

    // MARK: - Public
    func startUpdatingLocation() {
        setUp()
    }
    
    // MARK: - Lifecycle
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            print(LocationError.emptyLocation.localizedDescription)
            return
        }
        print("[LocationManager](updated)location")
        delegate?.locationManager(self, didUpdateLocation: location)
        reverseGeocodeLocation(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // MARK: - Private
    private func setUp() {
        locationManager.delegate = self
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                manager.requestLocation()
            default:
                manager.requestWhenInUseAuthorization()
            }
        }
    
    private func reverseGeocodeLocation(_ location: CLLocation) {
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else { return }
            var address = ""

            if let administrativeArea = placemark.administrativeArea { address += administrativeArea }

            if let locality = placemark.locality { address += " \(locality)" }

            if let subLocality = placemark.subLocality { address += " \(subLocality)" }

            if let thoroughfare = placemark.thoroughfare { address += " \(thoroughfare)" }

            if let subThoroughfare = placemark.subThoroughfare { address += " \(subThoroughfare)" }

        }
    }
}
