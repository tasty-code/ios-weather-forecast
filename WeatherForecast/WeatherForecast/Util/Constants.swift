//
//  Constants.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/14/23.
//

import Foundation
import UIKit

enum Constants {
    enum General {
        case cell(view: UIView)
        case header(view: UIView)
        
        var size: CGSize {
            switch self {
            case .cell(view: let view):
                return CGSize(width: view.frame.width, height: 60)
            case .header(view: let view):
                return CGSize(width: view.frame.size.width, height: 120)
            }
        }
    }
}
