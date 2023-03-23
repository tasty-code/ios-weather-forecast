//
//  AddressManager.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/23.
//

import Foundation
import CoreLocation

final class AddressManager {

    // MARK: - Properties

    private let geocoder = CLGeocoder()
    private(set) var placemark: CLPlacemark?

    // MARK: - Public

    func fetchAddress(of location: CLLocation, completion: @escaping (CLPlacemark?) -> () ) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self, error == nil else { return }

            guard let placemark = placemarks?.first else { return }
            self.placemark = placemark
            completion(placemark)
        }
    }

}
