//
//  DateFormattable.swift
//  WeatherForecast
//
//  Created by Swain Yun on 12/1/23.
//

import Foundation

protocol DateFormattable {
    func format(with dateText: String, from format1: String, to format2: String) -> String
}
