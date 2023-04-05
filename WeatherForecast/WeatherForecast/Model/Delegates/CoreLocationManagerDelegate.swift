//
//  Protocol.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/31.
//

import Foundation
import CoreLocation

protocol CoreLocationManagerDelegate: AnyObject {
    func coreLocationManager(_ manager: CoreLocationManager, didUpdateLocation location: CLLocation)
}

