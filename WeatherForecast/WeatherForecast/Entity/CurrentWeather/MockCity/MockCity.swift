//
//  City.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/14.
//

import Foundation

struct MockCity {
    let id: Double
    let name: String
    let findname: String?
    let coordinate: Coordinate
    let zoom: Int?
    let language: [Language]?
    let conuntry: String?
    
    private enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case language = "langs"
    }
}
