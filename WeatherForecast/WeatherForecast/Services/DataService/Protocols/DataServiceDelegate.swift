//
//  DataServiceDelegate.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/30/23.
//

import UIKit

protocol WeatherForecastDataServiceDelegate: AnyObject {
    func notifyWeatherModelDidUpdate(dataService: DataDownloadable, model: WeatherModel?)
    func notifyForecastModelDidUpdate(dataService: DataDownloadable, model: ForecastModel?)
}

protocol ImageDataServiceDelegate: AnyObject {
    func notifyImageDidUpdate(dataService: DataDownloadable, image: UIImage)
}
