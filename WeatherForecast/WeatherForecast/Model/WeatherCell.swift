//
//  WeatherCell.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/28.
//

import Foundation
import UIKit

final class WeatherCell: UICollectionViewCell {
    static let identifier = "WeatherCell"

    let label: UILabel = {
        let label = UILabel()
        label.text = "none"

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
