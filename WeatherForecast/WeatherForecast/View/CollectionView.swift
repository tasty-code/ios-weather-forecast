import UIKit

final class WeatherCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.register(ForecastWeatherCell.self, forCellWithReuseIdentifier: ForecastWeatherCell.identifier)
        self.register(HeaderCollectionReusableView.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: HeaderCollectionReusableView.identifier)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setCollectionViewConstraints(view: UIView) {
        view.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}
