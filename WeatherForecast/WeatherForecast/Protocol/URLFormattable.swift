//
//  URLFormattable.swift
//  WeatherForecast
//
//  Created by BOMBSGIE on 2023/11/21.
//

import Foundation

protocol URLFormattable {
    associatedtype T
    
    func makeURL(urlType: T, with queryDict: [String: String]) -> URL?
}
