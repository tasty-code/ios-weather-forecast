//
//  UIView.swift
//  WeatherForecast
//
//  Created by Rarla on 2023/11/30.
//

import UIKit

extension UIView {
    func addBorder(_ width: CGFloat, color: UIColor, alpha: CGFloat) {
         let border = CALayer()
         border.borderColor = color.withAlphaComponent(alpha).cgColor
         border.borderWidth = width
         border.frame = CGRect(x: 0 - width, y: 0 - width, width: self.frame.size.width + (width * 2), height: self.frame.size.height - width)
         self.layer.addSublayer(border)
         self.layer.masksToBounds = true
    }
}
