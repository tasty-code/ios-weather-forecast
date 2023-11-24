//
//  LocationDelegate.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/23/23.
//

import CoreLocation

protocol LocationDelegate: AnyObject {
    func location(_ manager: CLLocationManager, didLoad coordinate: CLLocationCoordinate2D)
}
