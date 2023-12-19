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
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 24)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cellIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dateLabel)
        addSubview(temperatureLabel)
        addSubview(cellIconImageView)
        
        configureCell()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.gray.cgColor
        borderLayer.frame = CGRect(x: 10, y: frame.size.height - 1, width: frame.size.width, height: 1)
        
        layer.addSublayer(borderLayer)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            // dateLabel
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            // temperatureLabel
            temperatureLabel.topAnchor.constraint(equalTo: self.topAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: cellIconImageView.leadingAnchor),
            
            // cellIconImageView
            cellIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellIconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            cellIconImageView.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
}
