//
//  Double.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/8/23.
//

import Foundation

extension Double {
    func kelvinToCelsius() -> Double {
        //guard let kelvin = self else { return 0 }
        return self - 273.15
    }
    
    func formatCelsius() -> String {
        let celsius = self.kelvinToCelsius()
        return String(format: "%.1f", celsius)
    }
}
