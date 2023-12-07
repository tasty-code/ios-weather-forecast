import UIKit

final class WeatherForecastView: UIView {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 500, height: 100)
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(WeatherForecastCell.self,
                                forCellWithReuseIdentifier: WeatherForecastCell.identifier)
        collectionView.register(WeatherForecastHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: WeatherForecastHeaderView.identifier)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUI() {
        self.backgroundColor = .blue
        self.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setConstraint() {
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

extension WeatherForecastView: UICollectionViewDelegate {
    
}

extension WeatherForecastView: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherForecastCell.identifier, for: indexPath)
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 50))
         title.text = "\(indexPath)"
         title.textAlignment = .center
         cell.addSubview(title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WeatherForecastHeaderView.identifier, for: indexPath) as? WeatherForecastHeaderView else {
            return UICollectionViewCell()
        }
        if let image = UIImage(systemName: "square.and.arrow.up") {
            header.configure(with: image)
        }
        return header
    }
}

extension WeatherForecastView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
}

#if DEBUG
import SwiftUI
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    
    // update
    func updateUIViewController(_ uiViewController: UIViewController, context: Context){
        
    }
    // makeui
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> UIViewController {
        WeatherForecastViewController()
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View{
        ViewControllerRepresentable().previewDisplayName("iPhone 15")
    }
}
#endif
