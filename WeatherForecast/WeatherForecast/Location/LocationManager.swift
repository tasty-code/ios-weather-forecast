//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/03/24.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager.init()
    private let geoCoder = CLGeocoder.init()

    // MARK: Function
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: Life Cycle
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
    
    // MARK: Private function
    private func reverseGeocodeLocation(_ location: CLLocation) {
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else { return }
            var address = ""

            if let administrativeArea = placemark.administrativeArea { address += administrativeArea }

            if let locality = placemark.locality { address += " \(locality)" }

            if let subLocality = placemark.subLocality { address += " \(subLocality)" }

            if let thoroughfare = placemark.thoroughfare { address += " \(thoroughfare)" }

            if let subThoroughfare = placemark.subThoroughfare { address += " \(subThoroughfare)" }

            print("address: ", address)
        }
    }
}
