import UIKit

class ForecastWeatherCell: UICollectionViewCell {
    
    static let identifier = "ForecastCell"
    
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        
        return stackView
    }()
    
    let dateLabel: UILabel = UILabel()
    let temperatureLabel: UILabel = UILabel()

    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
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
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

        ])
                                                
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weatherImageView.widthAnchor.constraint(equalTo: weatherImageView.heightAnchor, multiplier: 1),

        ])
    }
    
    func updateContent(_ forecastWeather: ForecastWeather, indexPath: IndexPath, icon: UIImage) {
        
        let date = forecastWeather.fiveDaysForecast[indexPath.row].dt
        guard let formattedDate = dateFormatter(date) else { return }
        
        DispatchQueue.main.async { [self] in
            dateLabel.text = formattedDate
            temperatureLabel.text = "\(forecastWeather.fiveDaysForecast[indexPath.row].temperature.temp)°"
            weatherImageView.image = icon
        }
    }
    
    private func dateFormatter(_ date: Int) -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        
        return dateFormatter.string(from: date)
        
    }
}
