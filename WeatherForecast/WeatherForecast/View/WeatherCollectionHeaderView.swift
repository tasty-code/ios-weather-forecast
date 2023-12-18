//
//  WeatherCollectionHeaderView.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/1/23.
//

import UIKit

class WeatherCollectionHeaderView: UICollectionReusableView {
    static let identifier = "CustomCollectionHeaderView"
    
    lazy var headerIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let maxAndMinTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 24)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerIconImageView)
        addSubview(addressLabel)
        addSubview(maxAndMinTemperatureLabel)
        addSubview(currentTemperatureLabel)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            // headerIconImageView
            headerIconImageView.topAnchor.constraint(equalTo: self.topAnchor),
            headerIconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerIconImageView.widthAnchor.constraint(equalToConstant: 120),
            headerIconImageView.heightAnchor.constraint(equalToConstant: 120),
            
            // addressLabel
            addressLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            addressLabel.leadingAnchor.constraint(equalTo: headerIconImageView.trailingAnchor),
            
            // maxAndMinTemperatureLabel
            maxAndMinTemperatureLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 16),
            maxAndMinTemperatureLabel.leadingAnchor.constraint(equalTo: headerIconImageView.trailingAnchor),
            
            // currentTemperatureLabel
            currentTemperatureLabel.topAnchor.constraint(equalTo: maxAndMinTemperatureLabel.bottomAnchor, constant: 16),
            currentTemperatureLabel.leadingAnchor.constraint(equalTo: headerIconImageView.trailingAnchor),
        ])
    }
}
