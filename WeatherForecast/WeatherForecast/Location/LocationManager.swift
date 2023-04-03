//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/03/24.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: - Private property
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()

    // MARK: - Public
    func startUpdatingLocation() {
        setUp()
        requestAuthorization()
        startUpdating()
    }
    
    // MARK: - Lifecycle
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            print(LocationError.emptyLocation.localizedDescription)
            return
        }
        print("(updated)location")
        NotificationCenter.default.post(name: Notification.Name.location, object: nil, userInfo: [NotificationKey.coordinate:location.coordinate])
        reverseGeocodeLocation(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // MARK: - Private
    private func setUp() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    private func startUpdating() {
        locationManager.startUpdatingLocation()
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

            print("placemark: ", placemark)
            print("description: ", placemark.description)
            print("address: ", address)
        }
    }
}
