import UIKit

final class ForecastWeatherCell: UICollectionViewCell {
    
    static let identifier = "ForecastCell"
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(weatherImageView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        
        addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        return temperatureLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
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
        
        NSLayoutConstraint.activate([
            weatherImageView.widthAnchor.constraint(equalTo: weatherImageView.heightAnchor, multiplier: 1)
        ])
    }
    
    func updateContent(_ forecastWeather: ForecastWeather, indexPath: IndexPath, icon: UIImage) {
        let date = forecastWeather.fiveDaysForecast[indexPath.row].dt
        guard let formattedDate = dateFormatter(date) else { return }
        
        dateLabel.text = formattedDate
        temperatureLabel.text = "\(forecastWeather.fiveDaysForecast[indexPath.row].temperature.temp)°"
        weatherImageView.image = icon
    }
    
    private func dateFormatter(_ date: Int) -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        
        return dateFormatter.string(from: date)
    }
}
