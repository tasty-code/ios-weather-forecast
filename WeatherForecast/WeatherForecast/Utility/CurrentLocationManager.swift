//
//  CurrentLocationManager.swift
//  WeatherForecast
//
//  Created by 김수경 on 2023/12/01.
//

import CoreLocation

final class CurrentLocationManager {
    private var locationInfo: CurrentLocationInfo?

}

extension CurrentLocationManager: CurrentLocationManagable {
    func updateLocationInfo(with placemark: CLPlacemark) {
        locationInfo = CurrentLocationInfo(
            coordinates: placemark.location?.coordinate,
            city: placemark.locality,
            district: placemark.subLocality
        )
    }
    
}
