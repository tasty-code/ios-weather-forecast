//
//  WeatherCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 12/1/23.
//

import UIKit

final class WeatherCollectionViewCell: UICollectionViewCell, WeatherCellDelegate {
    lazy var horizontalStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "time"
        return label
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "temp"
        return label
    }()
    
    lazy var weatherIcon: UIImageView = {
       let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = .actions
        return icon
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
        backgroundColor = .systemGreen
        horizontalStackView.setCustomSpacing(20, after: .spacerView)
        horizontalStackView.addArrangedSubviews([timeLabel, temperatureLabel, weatherIcon])
       
        addSubview(horizontalStackView)
        
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            horizontalStackView.heightAnchor.constraint(equalTo: self.heightAnchor),
        ])
    }
}
