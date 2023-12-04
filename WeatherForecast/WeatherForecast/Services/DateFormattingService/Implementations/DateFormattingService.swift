//
//  DateFormatter.swift
//  WeatherForecast
//
//  Created by Swain Yun on 12/1/23.
//

import Foundation

final class DateFormattingService: DateFormattable {
    private let dateFormatter = DateFormatter()
    
    func format(with dateText: String, from format1: String, to format2: String) -> String {
        dateFormatter.dateFormat = format1
        guard let date = dateFormatter.date(from: dateText) else { return String() }
        
        dateFormatter.dateFormat = format2
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        return dateFormatter.string(from: date)
    }
}
