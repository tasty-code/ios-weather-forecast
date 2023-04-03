//
//  HeaderView.swift
//  WeatherForecast
//
//  Created by J.E on 2023/04/03.
//

import UIKit

final class HeaderView: UIView {
    let image: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "rays"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let addressLabel = UILabel()
    let minMaxTemperatureLabel = UILabel()
    let temperatureLabel = UILabel()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        configureLayout()
        temperatureLabel.font = .preferredFont(forTextStyle: .title2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Expected \(Self.self) initialization did fail")
    }
    
    private func setupStackView() {
        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(minMaxTemperatureLabel)
        stackView.addArrangedSubview(temperatureLabel)
    }
    
    private func configureLayout() {
        self.addSubview(image)
        self.addSubview(stackView)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: self.topAnchor),
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            image.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            image.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -10),
            image.widthAnchor.constraint(equalTo: image.heightAnchor)
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        image.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
}
