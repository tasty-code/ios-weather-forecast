//
//  AddressManager.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/23.
//

import Foundation
import CoreLocation

final class AddressManager {
    let geocoder = CLGeocoder()

    func fetchAddress(of location: CLLocation, completion: @escaping (CLPlacemark?) -> () ) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else { return }

            guard let placemark = placemarks?.first else { return }
            completion(placemark)
        }
    }

}
