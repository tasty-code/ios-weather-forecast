//
//  DataDownloadable.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/30/23.
//

import Foundation

protocol DataDownloadable {
    func downloadData(serviceType: ServiceType)
}
