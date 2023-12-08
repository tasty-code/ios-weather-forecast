import UIKit

class ForecastWeatherCell: UICollectionViewCell {
    
    static let identifier = "ForecastCell"
    
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12/06(수) 00시"
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "45도"
        return label
    }()
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "test"))
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        return imageView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
        horizontalStackView.addArrangedSubview(temperatureLabel)
        horizontalStackView.addArrangedSubview(weatherImageView)
        
        addSubview(horizontalStackView)
        addSubview(dateLabel)
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateContent(_ forecastWeather: ForecastWeather, indexPath: IndexPath) {
        dateLabel.text = "\(forecastWeather.fiveDaysForecast[indexPath.row].dt)"
        temperatureLabel.text = "\(forecastWeather.fiveDaysForecast[indexPath.row].temperature.temp)°"
    }
}
