//
//  Rain.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/20.
//

import Foundation

struct Rain: Decodable {
    let volumeForLast3Hours: Double?

    enum CodingKeys: String, CodingKey {
        case volumeForLast3Hours = "3h"
    }
}
