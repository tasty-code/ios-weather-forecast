//
//  ReverseGeocodable.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/30/23.
//

import Foundation
import CoreLocation

protocol ReverseGeocodable {
    func reverseGeocodeLocation(location: CLLocation)
}
