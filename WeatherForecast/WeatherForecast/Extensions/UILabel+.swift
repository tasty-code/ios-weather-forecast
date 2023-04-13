//
//  UILabel+.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/04/12.
//

import UIKit

extension UILabel {
    
    convenience init(systemFontSize: CGFloat, textColor: UIColor) {
        self.init()
        self.font = .systemFont(ofSize: systemFontSize)
        self.textColor = textColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
