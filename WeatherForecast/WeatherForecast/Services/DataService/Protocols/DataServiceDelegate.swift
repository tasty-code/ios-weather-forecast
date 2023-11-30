//
//  DataServiceDelegate.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/30/23.
//

import Foundation

protocol DataServiceDelegate: AnyObject {
    func notifyWeatherModelDidUpdate(dataService: DataDownloadable, model: WeatherModel)
    func notifyForecastModelDidUpdate(dataService: DataDownloadable, model: ForecastModel)
}
