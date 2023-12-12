//
//  IconRequest.swift
//  WeatherForecast
//
//  Created by 김진웅 on 12/8/23.
//

import Foundation

struct IconRequest: APIRequest {
    let scheme: String = "https"
    let host: String = "openweathermap.org"
    let method: String = "GET"
    
    var path: String
    var parameters: [String : String]?
    
    init(_ id: String) {
        self.path = "/img/wn/\(id)@2x.png"
        self.parameters = nil
    }
}
