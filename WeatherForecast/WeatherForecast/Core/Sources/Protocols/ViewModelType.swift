//
//  ViewModelType.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(from input: Input) -> Output
}
