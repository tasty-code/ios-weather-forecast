//
//  DateFormatter.swift
//  WeatherForecast
//
//  Created by 김진웅 on 12/8/23.
//

import Foundation

extension DateFormatter {
    func toString(by date: Int) -> String {
        self.locale = Locale(identifier:"ko_KR")
        self.dateFormat = "MM/dd(E) HH시"
        
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let dateString = self.string(from: date)
        
        return dateString
    }
}
