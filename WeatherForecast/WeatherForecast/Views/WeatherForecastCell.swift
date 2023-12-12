import UIKit

protocol WeatherForecastCellIdentifying {
    static var identifier: String { get }
}

extension WeatherForecastCellIdentifying {
    static var identifier: String { String(describing: WeatherForecastCell.self) }
}

protocol WeatherForecastCellConfigurable {
    func startConfigure(using model: Model.FiveDaysWeather.List?) throws
}

final class WeatherForecastCell: UICollectionViewListCell {
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        
        return label
    }()
    
    private let temperatureCurrentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white

        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var cellRightStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.addArrangedSubview(temperatureCurrentLabel)
        stackView.addArrangedSubview(imageView)
        
        return stackView
    }()
    
    private lazy var cellTotalStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(cellRightStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func configureUI() {
        backgroundConfiguration = .clear()
        addSubview(dateLabel)
        addSubview(cellTotalStackView)
    }
    
    private func configureConstraint() {
        setStackViewConstraint()
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
    }
    
    private func setStackViewConstraint() {
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            cellTotalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            cellTotalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            cellTotalStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            cellTotalStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

extension WeatherForecastCell: WeatherForecastCellConfigurable {
    func startConfigure(using model: Model.FiveDaysWeather.List?) throws {
        guard let model = model else {
            throw WeatherForecastCellError.didFailFetchCellData
        }
        
        guard let imageType = model.weather?[0].icon else {
            throw WeatherForecastCellError.noExistedImage
        }

        guard let date = model.dt else {
            throw WeatherForecastCellError.noExistedDate
        }
        
        let dateString = DateFormatter.toString(by: date)
        
        guard let temperatureCurrent = model.main?.temp else {
            throw WeatherForecastCellError.noExistedTemperature
        }
        
        UIImage.load(from: imageType) { image in
            self.configure(image: image, date: dateString, temperatureCurrent: temperatureCurrent)
        }
    }

    private func configure(image: UIImage, date: String, temperatureCurrent: Double) {
        imageView.image = image
        dateLabel.text = date
        temperatureCurrentLabel.text = String(format: "%.1fº", temperatureCurrent)
    }
}

extension WeatherForecastCell: WeatherForecastCellIdentifying {
    
}
