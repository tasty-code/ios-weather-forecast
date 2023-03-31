//
//  Protocol.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/31.
//

import Foundation
import CoreLocation

protocol LocationDelegate: AnyObject {
    func didUpdateLocation()
}

