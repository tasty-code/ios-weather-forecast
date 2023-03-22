//
//  OSLog.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/21.
//

import Foundation
import OSLog

extension OSLog {
    
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let location = OSLog(subsystem: subsystem, category: "Location")
    static let network = OSLog(subsystem: subsystem, category: "Network")

}
