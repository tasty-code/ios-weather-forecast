import UIKit

final class CollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame,collectionViewLayout: layout)
        
        self.register(ForecastWeatherCell.self, forCellWithReuseIdentifier: ForecastWeatherCell.identifier)
        self.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
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
    
    private func setImageView(name: String) -> UIImageView? {
        guard let image = UIImage(named: name) else { return nil}
        let imageView = UIImageView(image: image)
        
        return imageView
    }
    
    
}

