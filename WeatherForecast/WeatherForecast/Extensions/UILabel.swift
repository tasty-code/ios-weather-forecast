//
//  UILabel.swift
//  WeatherForecast
//
//  Created by Rarla on 2023/12/01.
//

import UIKit

extension UILabel {
    convenience init(text: String, fontSize: CGFloat = 16) {
        self.init()
        self.text = text
        self.textColor = .white
        self.font = .systemFont(ofSize: fontSize)
    }
}
