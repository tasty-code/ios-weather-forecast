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
    
    let dateLabel: UILabel = UILabel()
    let temperatureLabel: UILabel = UILabel()

    let weatherImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "test"))
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
            weatherImageView.widthAnchor.constraint(equalTo: weatherImageView.heightAnchor)
        ])
    }
    
    func updateContent(_ forecastWeather: ForecastWeather, indexPath: IndexPath) {
        
        let date = forecastWeather.fiveDaysForecast[indexPath.row].dtTxt
        guard let formattedDate = dateFormatter(date) else { return }
        
        dateLabel.text = formattedDate
        temperatureLabel.text = "\(forecastWeather.fiveDaysForecast[indexPath.row].temperature.temp)°"
    }
    
    private func dateFormatter(_ date: String) -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.date(from: date) else { return nil }
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        
        return dateFormatter.string(from: date)
        
    }
}
