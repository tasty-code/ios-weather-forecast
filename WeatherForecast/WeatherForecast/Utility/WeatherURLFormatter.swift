//
//  WeatherURLFormatter.swift
//  WeatherForecast
//
//  Created by BOMBSGIE on 2023/11/21.
//

import Foundation

struct WeatherURLFormatter<T: URLProtocol>: URLFormattable {
    
    var defaultPath: String
    
    init(defaultPath: String = "/data/2.5/") {
        self.defaultPath = defaultPath
    }
    
}
