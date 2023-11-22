//
//  Errors.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 2023/11/22.
//

import Foundation

enum KeyError : Error, CustomStringConvertible {
    case keyFileNotFound, keyNotFound
    
    var description: String {
        switch self {
        case .keyFileNotFound:
            return "키 파일을 찾을수 없습니다."
        case .keyNotFound:
            return "키를 찾을수 없습니다."
        }
    }
}
