//
//  URLSessionDataTaskProtocol.swift
//  WeatherForecast
//
//  Created by 김진웅 on 11/23/23.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
