//
//  AddressManager.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/23.
//

import CoreLocation

final class AddressManager {

    // MARK: - Properties

    private let geocoder = CLGeocoder()
    private(set) var placemark: CLPlacemark?
    var address: String { "\(placemark?.locality ?? "") \(placemark?.name ?? "")" }

    // MARK: - Public

    func fetchAddress(of location: CLLocation, completion: ((CLPlacemark?) -> Void)? = nil) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self, error == nil else { return }

            guard let placemark = placemarks?.first else { return }
            self.placemark = placemark
            completion?(placemark)
        }
    }

}
