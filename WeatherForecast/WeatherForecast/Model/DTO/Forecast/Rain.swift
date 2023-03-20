//
//  Rain.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/20.
//

import Foundation

struct Rain: Decodable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}
