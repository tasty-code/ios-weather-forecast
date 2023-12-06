//
//  ForecastCell.swift
//  WeatherForecast
//
//  Created by 김경록 on 12/1/23.
//

import UIKit

class ForecastCell: UICollectionViewCell, Reusable {
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel(textAlignment: .left)
        addSubview(label)
        
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel(textAlignment: .right)
        
        return label
    }()
    
    private lazy var weatherIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var weatherInfoStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal,
                                    distribution: .fill,
                                    spacing: 5,
                                    subViews: [temperatureLabel, weatherIconView])
        addSubview(stackView)
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            weatherInfoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    func configureUI(with data: List) {
        guard let formattedString = formatDateString(data.TimeOfDataForecastedTxt),
              let iconID = data.weather.last
        else {
            return
        }
        let temperature = data.weatherCondition.temperature
        dateLabel.text = formattedString
        temperatureLabel.text = "\(temperature)℃"
        
    }
    
    private func formatDateString(_ input: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko-KR")
        guard let date = dateFormatter.date(from: input) else {
            return nil
        }
        
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        let output = dateFormatter.string(from: date)
        
        return output
    }
}
