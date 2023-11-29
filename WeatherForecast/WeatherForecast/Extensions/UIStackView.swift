//
//  UIStackView.swift
//  WeatherForecast
//
//  Created by Janine on 11/29/23.
//

import UIKit

extension UIStackView {
    func addArrangedSubViews(_ subviews: UIView...) {
        subviews.forEach { subview in
            self.addArrangedSubview(subview)
        }
    }
}
