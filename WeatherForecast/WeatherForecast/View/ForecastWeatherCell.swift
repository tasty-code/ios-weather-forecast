import UIKit

final class ForecastWeatherCell: UICollectionViewCell {
    
    static let identifier = "ForecastCell"
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        
        contentView.addSubview(stackView)
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
        
        contentView.addSubview(dateLabel)
        
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
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: horizontalStackView.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: horizontalStackView.bottomAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weatherImageView.widthAnchor.constraint(equalTo: weatherImageView.heightAnchor, multiplier: 1),
            weatherImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height)
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
