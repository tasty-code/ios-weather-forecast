//
//  WeatherViewHeader.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/30.
//

import Foundation
import UIKit

final class WeatherViewHeader: UICollectionReusableView {
    static let identifier = "WeatherViewHeader"

    private let weatherIcon : UIImage = {
        let image = UIImage()
        return image
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let maxMinTemperutureLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let temperutureLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
