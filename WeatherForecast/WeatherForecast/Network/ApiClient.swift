//
//  ApiClient.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/21/23.
//

import Foundation

protocol ApiClient {
    var components: URLComponents? { get } // TODO: 왜 set 안해도 돌아가는가?
}
