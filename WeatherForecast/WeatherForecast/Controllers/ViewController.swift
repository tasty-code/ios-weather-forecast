//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let weatherManager = WeatherManager()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WeatherTimeViewCell.self, forCellWithReuseIdentifier: WeatherTimeViewCell.identifier)
        
        weatherManager.delegate = self
        weatherManager.startLocationUpdate()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 50)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherTimeViewCell.identifier, for: indexPath) as? WeatherTimeViewCell else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .red
        
        return cell
    }
}
extension ViewController: UICollectionViewDelegate {}

extension ViewController: WeatherManagerDelegate {
    func showAlertWhenNoAuthorization() {
        let alert = UIAlertController(title: nil, message: "설정>앱>위치에서 변경 가능", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "설정으로 이동", style: .default)  { _ in
            guard let url = URL(string:UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }
        let noAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
}
