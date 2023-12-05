//
//  WeatherCollectionCellView.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/1/23.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeatherCollectionViewCell"
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12/02(일) 21시"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "1.9"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var weatherIconImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dateLabel)
        addSubview(temperatureLabel)
        addSubview(weatherIconImageView2)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: 필요한가? 정확한 역할 알아내기
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            // dateLabel
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor),
            // TODO: 왜 주석을 풀면 에러가 날까?
            // dateLabel.leadingAnchor.constraint(equalTo: self.leftAnchor),
            
            // temperatureLabel
            temperatureLabel.topAnchor.constraint(equalTo: self.topAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: weatherIconImageView2.leadingAnchor),
            
            // weatherIconImageView
            weatherIconImageView2.topAnchor.constraint(equalTo: self.topAnchor),
            weatherIconImageView2.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    
}
