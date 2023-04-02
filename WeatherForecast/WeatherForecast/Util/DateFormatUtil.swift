//
//  DateFormatUtil.swift
//  WeatherForecast
//
//  Created by Mason Kim on 2023/04/03.
//

import Foundation

enum DateFormatUtil {
    
    // MARK: - Properties
    
    private static let convertFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private static let resultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd(EEE) HH시"
        return formatter
    }()
    
    // MARK: - Public
    
    static func format(with dateString: String) -> String {
        guard let date = convertFormatter.date(from: dateString) else {
            return "00/00(000) 00시"
        }

        let formattedDate = resultFormatter.string(from: date)
        return formattedDate
    }

}
