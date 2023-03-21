//
//  Rain.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/03/14.
//

import Foundation

struct Rain: Decodable {
    let oneHours: Double
    let threeHours: Double

    private enum CodingKeys: String, CodingKey {
        case oneHours = "1h"
        case threeHours = "3h"
    }
}
