//
//  LogUtil.swift
//  WeatherForecast
//
//  Created by Mason Kim on 2023/03/22.
//

import Foundation
import OSLog

func log(_ log: OSLog, error: Error) {
    os_log(.error, log: log, "%@", error.localizedDescription)
}
