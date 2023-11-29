//
//  CurrentWeatherCollectionReusableView.swift
//  WeatherForecast
//
//  Created by Rarla on 2023/11/29.
//

import UIKit

class CurrentWeatherCollectionReusableView: UICollectionReusableView {
    static let identifier = "CurrentWeather"
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .systemGray
        return stackView
    }()
    
    private let detailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "용산구"
        label.textColor = .white
        return label
    }()
    
    private let maxMinTempertureLabel: UILabel = {
        let label = UILabel()
        label.text = "최저"
        label.textColor = .white
        return label
    }()
    
    private let tempertureLabel: UILabel = {
        let label = UILabel()
        label.text = "11.0"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainStackView.addArrangedSubViews(iconImageView, detailStackView)
        addSubview(mainStackView)
        
        detailStackView.addArrangedSubViews(addressLabel, maxMinTempertureLabel, tempertureLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainStackView.frame = bounds
    }
}
