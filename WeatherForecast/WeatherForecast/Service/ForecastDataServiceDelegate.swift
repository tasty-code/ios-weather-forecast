//
//  ForecastDataServiceDelegate.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/8/23.
//

import Foundation

protocol ForecastDataServiceDelegate: AnyObject {
    func forecastDataService(_ service: ForecastDataService, didDownload data: WeatherForecast)
}
