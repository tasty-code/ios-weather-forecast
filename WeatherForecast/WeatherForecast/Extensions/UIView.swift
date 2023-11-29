//
//  UIView.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/29/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
