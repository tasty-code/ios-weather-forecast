//
//  LacationInfo.swift
//  WeatherForecast
//
//  Created by 김진웅 on 11/24/23.
//

import Foundation
import CoreLocation

struct LocationData {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let address: String
    
    init(coordinate: CLLocationCoordinate2D, address: String) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.address = address
    }
}
