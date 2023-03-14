//
//  Rain.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/03/14.
//

import Foundation

struct Rain {
    var threeHours: Double

    private enum CodingKeys: String, CodingKey {
        case threeHours = "3h"
    }
}
