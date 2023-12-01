//
//  UIStackView+convenienceInit.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/29/23.
//

import UIKit

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, spacing: CGFloat = 0.0, backgroundColor: UIColor = .clear) {
        self.init()
        
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
        self.backgroundColor = backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
    
    func removeArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}

