//
//  UIView+Extension.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 12/14/23.
//

import UIKit

extension UIView {
    public static var spacerView: UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.dragThatCannotResizeScene, for: .horizontal)
        return view
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
