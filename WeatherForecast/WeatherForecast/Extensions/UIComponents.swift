//
//  UIComponents.swift
//  WeatherForecast
//
//  Created by 김진웅 on 12/1/23.
//

import UIKit

extension UILabel {
    convenience init(font: UIFont = .preferredFont(forTextStyle: .body), textColor: UIColor = .label, textAlignment: NSTextAlignment = .natural) {
        self.init()
        
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment = .center, distribution: UIStackView.Distribution = .fillEqually, spacing: CGFloat = 0.0, subViews: [UIView] = []) {
        self.init()
        
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
        subViews.forEach {
            self.addArrangedSubview($0)
        }
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
