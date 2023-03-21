//
//  URLComponentsError.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/03/21.
//

import Foundation

enum URLComponentsError {
    case invalidComponent
}

extension URLComponentsError: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString("Compoent's requirements are not met \(self)", comment: "")
    }
}
