//
//  LocationDelegate.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/23/23.
//

import CoreLocation

protocol LocationDataManagerDelegate: AnyObject {
    func location(_ manager: LocationDataManager, didLoadCoordinate location: CLLocationCoordinate2D)
    func loaction(_ manager: LocationDataManager, didCompletePlcamark location: CLPlacemark?)
    func viewRequestLocationSettingAlert()
}
