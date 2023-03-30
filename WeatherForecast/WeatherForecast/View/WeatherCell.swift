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

    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12/44(천) 32시"
        label.backgroundColor = .brown
        return label
    }()

    let temperutuerLabel: UILabel = {
        let label = UILabel()
        label.text = "12.5"
        label.backgroundColor = .cyan
        return label
    }()



    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dateLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dateLabel.frame = contentView.bounds
    }
}
