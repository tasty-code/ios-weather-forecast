//
//  UserLocation.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/23.
//

import CoreLocation

enum UserLocationError: Error {
    case withoutZipCode
}

final class UserLocation: NSObject, CLLocationManagerDelegate {
    
    static let shared = UserLocation()
    
    var location: CLLocation? {
        sharedLocationManager.location
    }

    lazy var sharedLocationManager: CLLocationManager = {
        let newLocationmanager = CLLocationManager()
        newLocationmanager.delegate = self

        return newLocationmanager
    }()

    func authorize() {
        sharedLocationManager.requestWhenInUseAuthorization()
    }

    func address() async throws -> String {
        guard let newLocation = location else {
            throw UserLocationError.withoutZipCode
        }

        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(newLocation)

        guard let placemark = placemarks.first,
           let address = placemark.formattedAddress else {
            throw UserLocationError.withoutZipCode
        }

        return address
    }
}

private extension CLPlacemark {
    var formattedAddress: String? {
        var address = String()

        guard let locality = self.locality,
              let subLocality = self.subLocality else {
            return nil
        }

        address += locality + " " + subLocality

        return address
    }
}
