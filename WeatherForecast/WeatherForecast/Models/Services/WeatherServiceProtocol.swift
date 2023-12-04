//
//  WeatherServiceProtocol.swift
//  WeatherForecast
//
//  Created by Janine on 12/1/23.
//

import Foundation

protocol WeatherServiceProtocol {
    associatedtype serviceType
    
    var isNetworkingDone: Bool { get set }
    var request: URLRequest? { get set }
    
    func fetcher(_ completionHandler: @escaping (_ data: serviceType) -> Void)
}
