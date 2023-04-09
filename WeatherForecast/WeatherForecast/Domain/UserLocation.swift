//
//  UserLocation.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/23.
//

import CoreLocation

enum UserLocationError: Error {
    case withoutLocationInfomation
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
        switch sharedLocationManager.authorizationStatus {
        case .denied:
            print("위치 정보 권한이 필요합니다")
        case .notDetermined, .restricted:
            sharedLocationManager.requestWhenInUseAuthorization()
        default:
            return
        }
    }

    func address(complition: @escaping (String?, Error?) -> Void) {
        guard let newLocation = location else {
            complition(nil, UserLocationError.withoutLocationInfomation)
            return
        }

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(newLocation) { (placemarks, error) in
            guard error == nil else {
                complition(nil, error)
                return
            }

            guard let placemark = placemarks?.first,
               let address = placemark.formattedAddress else {
                complition(nil, UserLocationError.withoutZipCode)
                return
            }
            complition(address, nil)
        }
    }
}

private extension CLPlacemark {
    var formattedAddress: String? {
        var address = String()

        if let locality = self.locality {
            address = locality
        }

        if let subLocality = self.subLocality {
            address += " " + subLocality
        }

        return address
    }
}
