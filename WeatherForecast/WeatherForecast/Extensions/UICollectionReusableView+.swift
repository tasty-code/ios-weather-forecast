//
//  UICollectionReusableView+.swift
//  WeatherForecast
//
//  Created by 송선진 on 2023/04/05.
//

import UIKit

extension UICollectionReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
