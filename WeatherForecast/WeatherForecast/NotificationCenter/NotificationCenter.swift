//
//  NotificationCenter.swift
//  WeatherForecast
//
//  Created by 신동오 on 2023/03/28.
//

import Foundation

extension Notification.Name {
    static let location = Notification.Name("Location")
}

enum NotificationKey {
    case coordinate
}
