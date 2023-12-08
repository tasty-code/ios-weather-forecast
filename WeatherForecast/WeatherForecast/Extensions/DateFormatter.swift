//
//  DateFormatter.swift
//  WeatherForecast
//
//  Created by 김진웅 on 12/8/23.
//

import Foundation

extension DateFormatter {
    func formatDateString(_ dateString: String) -> String? {
        self.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.locale = Locale(identifier: "ko_KR")
        guard let date = self.date(from: dateString) else {
            return nil
        }
        
        self.dateFormat = "MM/dd(E) HH시"
        let output = self.string(from: date)
        
        return output
    }
}
