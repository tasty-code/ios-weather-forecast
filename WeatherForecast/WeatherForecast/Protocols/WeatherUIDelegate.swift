//
//  WeatherUpadateDelegate.swift
//  WeatherForecast
//
//  Created by 김준성 on 11/27/23.
//

import CoreLocation
import UIKit

protocol WeatherUIDelegate: UIViewController {
    func updateLocationWeather(_ coordinate: CLLocationCoordinate2D, _ addressString: String)
}
