//
//  String+.swift
//  WeatherForecast
//
//  Created by J.E on 2023/03/31.
//

import Foundation

extension String {
    init(utcTime: Int) {
        let date = Date(timeIntervalSince1970: TimeInterval(utcTime))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM/dd(EE) HH시"
        self = formatter.string(from: date)
    }
    
    init(temperature: Double) {
        let formattedTemperature = String(format: "%.1f", temperature)
        self = formattedTemperature + "°"
    }
}
