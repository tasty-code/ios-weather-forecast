//
//  TodayDataServiceDelegate.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/8/23.
//

import Foundation

protocol TodayDataServiceDelegate: AnyObject {
    func todayDataService(_ service: TodayDataService, didDownload data: WeatherToday)
}
