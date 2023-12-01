//
//  String.swift
//  WeatherForecast
//
//  Created by Rarla on 2023/12/01.
//

import Foundation

extension String {
    func dateFormatter() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.date(from: self) else { return nil }
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        
        let textString = dateFormatter.string(from: date)
        return textString
    }
}
