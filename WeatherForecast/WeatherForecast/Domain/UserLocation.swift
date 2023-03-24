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
    
    //MARK: - Property
    static let shard = UserLocation()
    
    var location: CLLocation? {
        sharedLocationManager.location
    }

    lazy var sharedLocationManager: CLLocationManager = {
        let newLocationmanager = CLLocationManager()
        newLocationmanager.delegate = self
        return newLocationmanager
    }()

    //MARK: - Authorization
    func authorize() {
        sharedLocationManager.requestWhenInUseAuthorization()
    }

    func address(completion: @escaping (Result<String, Error>) -> Void) {
        guard let newLocation = location else {
            completion(.failure(UserLocationError.withoutZipCode))
            return
        }

        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(newLocation) { (placemark, error) in
            guard error == nil else { return }
            if let placemark = placemark?.first,
               let address = placemark.formattedAddress {
                completion(.success(address))
            }
        }
    }
}

private extension CLPlacemark {
    var formattedAddress: String? {
        guard let infomation = self.addressDictionary?["FormattedAddressLines"] as? [String],
              let value = infomation.first else {
            // 우편번호가 없는 경우
            return nil
        }

        return value.split(separator: " ")[1...2].joined(separator: " ")
    }
}
