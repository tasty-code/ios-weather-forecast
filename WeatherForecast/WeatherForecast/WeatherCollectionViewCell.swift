//
//  WeatherCollectionViewCell.swift
//  WeatherForecast
//
//  Created by 신동오 on 2023/04/05.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static property
    static let cellIdentifier = "WeatherCollectionViewCell"

    // MARK: - Public property
    var indexpathLabel = UILabel()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        
        super.init(frame: frame)

        addSubview(indexpathLabel)
        configureLabelConstraint()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private function
    private func configureLabelConstraint() {
        indexpathLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            indexpathLabel.topAnchor.constraint(equalTo: self.topAnchor),
            indexpathLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            indexpathLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            indexpathLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
