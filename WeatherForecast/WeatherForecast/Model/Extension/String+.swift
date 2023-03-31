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
        let date = Date(timeIntervalSinceReferenceDate: TimeInterval(utcTime))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM/dd(EE) HH시"
        self = formatter.string(from: date)
    }
    
    init(place: CLLocation) {
        var address = ""
        CLGeocoder().reverseGeocodeLocation(place) { places, error in
            guard let place = places?.first else { return }
            address = place.administrativeArea! + " " + place.thoroughfare!
        }
        self = address
    }
    
    init(temperature: Double) {
        self = "\(temperature)°"
    }
}
