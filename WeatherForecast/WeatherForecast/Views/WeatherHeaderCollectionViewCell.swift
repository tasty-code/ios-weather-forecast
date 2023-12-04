//
//  WeatherHeaderCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 12/1/23.
//

import UIKit

class WeatherHeaderCollectionViewCell: UICollectionReusableView {
    var text: String = "없음"
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayouts()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpLayouts() {
        backgroundColor = .cyan
        addSubview(label)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.heightAnchor.constraint(equalTo: self.heightAnchor),
        ])
    }
}
