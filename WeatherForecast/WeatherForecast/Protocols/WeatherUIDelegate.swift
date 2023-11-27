//
//  WeatherUpadateDelegate.swift
//  WeatherForecast
//
//  Created by 김준성 on 11/27/23.
//

import Foundation
import CoreLocation

protocol WeatherUIDelegate: ViewController {
    func loadForecast(_ coordinate: CLLocationCoordinate2D)
    func updateAddress(_ addressString: String)
}
