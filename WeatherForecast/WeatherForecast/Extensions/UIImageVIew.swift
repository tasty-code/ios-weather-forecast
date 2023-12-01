//
//  UIImageVIew.swift
//  WeatherForecast
//
//  Created by Rarla on 2023/12/01.
//

import UIKit

extension UIImageView {
    convenience init(contentMode: UIView.ContentMode) {
        self.init()
        self.clipsToBounds = true
        self.contentMode = contentMode
    }
}
