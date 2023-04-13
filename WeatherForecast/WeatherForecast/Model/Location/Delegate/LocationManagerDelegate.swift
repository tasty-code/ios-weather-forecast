//
//  LocationManagerDelegate.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/04/07.
//

import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func fetchData()
}
