//
//  WeatherNetworkManagerDelegate.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/8/23.
//

import Foundation

protocol WeatherNetworkManagerDelegate {
    func weatherIcon(_ manager: WeatherNetworkManager, didLoad data: Data)
}
