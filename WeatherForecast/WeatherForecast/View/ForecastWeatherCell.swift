//
//  ForecastWeatherCell.swift
//  WeatherForecast
//
//  Created by J.E on 2023/04/03.
//

import UIKit

final class ForecastWeatherCell: UICollectionViewCell {
    static let id = "forecast"
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Expected \(Self.self) initialization did fail")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    private func configureLabel() {
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
}
