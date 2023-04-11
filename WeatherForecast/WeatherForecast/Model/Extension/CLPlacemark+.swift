//
//  CLPlacemark+.swift
//  WeatherForecast
//
//  Created by Blu on 2023/04/11.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    func formatAddress() -> String {
        var city: String?
        var district: String?

        if self.locality == nil {
            city = self.subAdministrativeArea
            district = self.subLocality
        } else {
            city = self.locality
            district = self.subLocality
        }

        guard let city,
              let district else {
            return ""
        }

        return city + " " + district
    }
}
