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

    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        print("latitude: ", location.coordinate.latitude)
        print("longitude: ", location.coordinate.longitude)

        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else { return }
            var address = ""

            if let administrativeArea = placemark.administrativeArea { address += administrativeArea }

            if let locality = placemark.locality { address += " \(locality)" }

            if let subLocality = placemark.subLocality { address += " \(subLocality)" }

            if let thoroughfare = placemark.thoroughfare { address += " \(thoroughfare)" }

            if let subThoroughfare = placemark.subThoroughfare { address += " \(subThoroughfare)" }

            print(placemark)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
