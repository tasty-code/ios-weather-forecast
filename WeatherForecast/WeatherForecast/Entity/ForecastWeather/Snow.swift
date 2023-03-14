//
//  Snow.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/14.
//

import Foundation

struct Snow {
    let oneHours: Double
    let threeHours: Double
    
    private enum CodingKeys: String, CodingKey {
        case oneHours = "1h"
        case threeHours = "3h"
    }
}
