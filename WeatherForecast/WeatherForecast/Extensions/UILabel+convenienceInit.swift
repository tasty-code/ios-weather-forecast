//
//  UILabel+convenienceInit.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/29/23.
//

import UIKit

extension UILabel {
    convenience init(text: String = "Label", font: UIFont, textColor: UIColor = .label, backgroundColor: UIColor = .clear, textAlignment: NSTextAlignment = .center) {
        self.init()
        
        self.text = text
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.textAlignment = textAlignment
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
