import UIKit

class ForecastWeatherCell: UICollectionViewCell {
    
    static let identifier = "ForecastCell"
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12/06(수) 00시"
        label.textAlignment = .left
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "45도"
        return label
    }()
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "sunny"))
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return imageView
    }()
    
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
        horizontalStackView.addArrangedSubview(dateLabel)
        horizontalStackView.addSpacer()
        horizontalStackView.addArrangedSubview(temperatureLabel)
        horizontalStackView.addArrangedSubview(weatherImageView)
        
        addSubview(horizontalStackView)
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension UIStackView {
    func addSpacer() {
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        addArrangedSubview(spacerView)
    }
}
