import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "Header"
    
    let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    let headerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "sunny"))
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return imageView
    }()
    
    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "서울특별시 세종로"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "최저 온도 최고 온도"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 기온"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderStackView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupHeaderStackView() {
        addSubview(headerStackView)
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        headerStackView.addArrangedSubview(headerImageView)
        headerStackView.addArrangedSubview(infoStackView)
        
        infoStackView.addArrangedSubview(locationLabel)
        infoStackView.addArrangedSubview(temperatureLabel)
        infoStackView.addArrangedSubview(currentTemperatureLabel)
    }
}
