//
//  Reusable.swift
//  WeatherForecast
//
//  Created by 김진웅 on 12/1/23.
//

import Foundation

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
