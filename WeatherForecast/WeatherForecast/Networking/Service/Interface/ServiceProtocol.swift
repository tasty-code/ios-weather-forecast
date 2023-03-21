//
//  ServiceProtocol.swift
//  WeatherForecast
//
//  Created by Mason Kim on 2023/03/20.
//

import Foundation

protocol ServiceProtocol {
    
    func performRequest(with url: URL?,
                        httpMethodType: HTTPMethodType,
                        completion: @escaping (Result<Data, NetworkError>) -> Void)
    
}
