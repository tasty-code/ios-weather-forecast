//
//  WeatherAPIProtocol.swift
//  WeatherForecast
//
//  Created by Janine on 11/29/23.
//

import Foundation

protocol WeatherAPIProtocol {
    associatedtype DataType
    
    var dataType: DataType.Type { get set }
    var apiType: Endpoint { get set }
}
