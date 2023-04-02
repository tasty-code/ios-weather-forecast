//
//  DateFormatter+.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/04/02.
//

import Foundation

extension DateFormatter {

    func dateString(with dateString: String) -> String {
        self.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = self.date(from: dateString) else { return "Formatting dateString fail"}

        self.dateFormat = "MM/dd(EEE) HH시"
        let formattedDate = self.string(from: date)

        return formattedDate
    }
    
}
