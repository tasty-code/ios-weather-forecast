//
//  URLFormattable.swift
//  WeatherForecast
//
//  Created by BOMBSGIE on 2023/11/21.
//

import Foundation

protocol URLFormattable {
    func makeURL(path: String, with queries: [String: String]) -> URL?
}
