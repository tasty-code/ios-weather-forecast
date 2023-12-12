//
//  Date.swift
//  WeatherForecast
//
//  Created by 김준성 on 12/12/23.
//

import Foundation

extension Date {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.dateFormat = "MM/dd(E) HH시"
        return formatter
    }()
    
    func asFormattedString() -> String { 
        Self.formatter.string(from: self)
    }
}
