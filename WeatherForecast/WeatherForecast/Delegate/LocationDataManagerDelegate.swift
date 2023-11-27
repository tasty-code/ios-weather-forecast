//
//  LocationDelegate.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/23/23.
//

import CoreLocation

protocol LocationDataManagerDelegate: AnyObject {
    func location(_ manager: LocationDataManager, didLoad coordinate: CLLocationCoordinate2D)
}
