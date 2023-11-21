//
//  WeatherURLFormatter.swift
//  WeatherForecast
//
//  Created by BOMBSGIE on 2023/11/21.
//

import Foundation

struct WeatherURLFormatter: URLFormattable {
    private let defaultPath: String
    private let formatter: URLFormattable
    
    init(defaultPath: String = "/data/2.5/",
         formatter: URLFormattable = URLFormatter<WeatherURL>()) {
        self.defaultPath = defaultPath
        self.formatter = formatter
    }
    
    func makeURL(path: String, with queries: [String : String]) -> URL? {
        let weatherAPIPath = defaultPath + "\(path)"
        return formatter.makeURL(path: weatherAPIPath, with: queries)
    }
}
