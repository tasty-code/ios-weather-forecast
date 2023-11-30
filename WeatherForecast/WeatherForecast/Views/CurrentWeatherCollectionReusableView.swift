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
        label.text = "-"
        label.textColor = .white
        return label
    }()
    
    private let maxMinTempertureLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .white
        return label
    }()
    
    private let tempertureLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
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
    
    func setMainIcon(_ iconId: String) {
        let url = URL(string: "https://openweathermap.org/img/wn/\(iconId)@2x.png")
        do {
            let data = try Data(contentsOf: url!)
            
            DispatchQueue.main.async {
                self.iconImageView.image = UIImage(data: data)
            }
        } catch let error {
            print(error)
        }
    }
    func setAddressLabel(_ address: String) {
        addressLabel.text = address
    }
    func setMaxMinTempertureLabel(max: Double?, min: Double?) {
        guard let max = max, let min = min else { return }
        maxMinTempertureLabel.text = "최저 \(min)° 최고 \(max)°"
    }
    func setTempertureLabel(_ temp: Double?) {
        guard let temp = temp else { return }
        tempertureLabel.text = "\(temp)°"
    }
    
}
