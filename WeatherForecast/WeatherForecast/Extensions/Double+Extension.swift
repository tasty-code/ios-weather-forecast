//
//  Double.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 12/11/23.
//

import Foundation

extension Double {
    func temperatureFormatter() -> String {
        return String(format: "%.1f", self)
    }
}
