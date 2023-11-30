//
//  CurrentLocationInfo.swift
//  WeatherForecast
//
//  Created by 김수경 on 2023/11/30.
//

import Foundation
import CoreLocation

struct CurrentLocationInfo {
    var coordinates: CLLocationCoordinate2D?
    var city: String?
    var district: String?
}

