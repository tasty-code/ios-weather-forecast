//
//  Language.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/14.
//

import Foundation

struct Language {
    let korea: String
    let korean: String
    let link: String
    
    private enum CodingKeys: String, CodingKey {
        case korea = "kr"
        case korean = "ko"
    }
}
