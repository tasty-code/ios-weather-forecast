//
//  IconDataServiceDelegate.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/8/23.
//

import Foundation

protocol IconDataServiceDelegate: AnyObject {
    func didCompleteLoad(_ service: IconDataService)
}
