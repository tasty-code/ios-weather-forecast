//
//  String+.swift
//  WeatherForecast
//
//  Created by J.E on 2023/03/31.
//

import Foundation
import CoreLocation

extension String {
    init(utcTime: Int) {
        let date = Date(timeIntervalSince1970: TimeInterval(utcTime))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM/dd(EE) HH시"
        self = formatter.string(from: date)
    }
    
    init?(place: CLPlacemark) {
        guard let administrativeArea = place.administrativeArea,
              let thoroughfare = place.thoroughfare else { return nil }
        self = administrativeArea + " " + thoroughfare
    }
    
    init(temperature: Double) {
        let formattedTemperature = String(format: "%.1f", temperature)
        self = formattedTemperature + "°"
    }
}
