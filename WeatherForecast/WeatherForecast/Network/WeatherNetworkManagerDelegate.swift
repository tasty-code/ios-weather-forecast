//
//  WeatherNetworkManagerDelegate.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/29/23.
//

import Foundation

protocol WeatherNetworkManagerDelegate: AnyObject {
    func weather<T: Decodable>(_ manager: WeatherNetworkManager, didLoad data: T)
}
