//
//  DataServiceable.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/8/23.
//

import Foundation

protocol DataServiceable: AnyObject {
    var decoder: JSONDecoder { get }
    var networkManager: WeatherNetworkManager { get }
    
    func downloadData(type service: ServiceType) throws
}

extension DataServiceable {
    var decoder: JSONDecoder {
        return JSONDecoder()
    }
    var networkManager: WeatherNetworkManager {
        return WeatherNetworkManager()
    }
}
