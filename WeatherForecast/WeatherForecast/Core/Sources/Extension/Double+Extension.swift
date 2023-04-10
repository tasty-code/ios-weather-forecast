//
//  Double+Extension.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

extension Double {
    
    func doubleToString() -> String? {
        return self.description
    }
    
    func makeCelsius() -> String {
        let argue = self - 273.15
        return String(format: "%.0f", arguments: [argue])
    }
}
