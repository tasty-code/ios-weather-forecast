//
//  Array+SafeIndex.swift
//  WeatherForecast
//
//  Created by Mason Kim on 2023/04/03.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
