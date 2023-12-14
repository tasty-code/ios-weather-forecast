//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    private let locationDataManager = LocationDataManager()
    private let dataManager = WeatherDataManager()
    private let imageFileManager = ImageFileManager()
    
    private var backgroundImageView: UIImageView!
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setRefreshControl()
        
        locationDataManager.locationDelegate = self
        dataManager.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDelegate

extension WeatherViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

// MARK: - UICollectionViewDataSource

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.forecast?.list.count ?? 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as? WeatherCollectionViewCell else {
            return UICollectionViewCell()
        }
        if dataManager.forecast != nil {
            bind(on: cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: WeatherCollectionHeaderView.identifier,
            for: indexPath) as? WeatherCollectionHeaderView else {
            return UICollectionReusableView()
        }
        if dataManager.address != nil, dataManager.today != nil {
            bind(on: header)
        }
        
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 120)
    }
}

// MARK: - Set ViewController UI

extension WeatherViewController {
    private func setUI() {
        collectionView = {
          let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .vertical
           layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
           
           let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
           view.register(
               WeatherCollectionViewCell.self,
               forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier
           )
           view.register(
               WeatherCollectionHeaderView.self,
               forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
               withReuseIdentifier: WeatherCollectionHeaderView.identifier
           )
            view.backgroundColor = UIColor(white: 1, alpha: 0)
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
       }()
        
        backgroundImageView  = {
            let imageView = UIImageView(frame: .zero)
            imageView.image = UIImage(named: "isaiah")
            imageView.alpha = 0.7
            imageView.contentMode = .scaleToFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        view.addSubview(collectionView)
        view.insertSubview(backgroundImageView, at: 0)
        setConstraint()
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            // collectionView
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            // imageView
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - LocationDataManagerDelegate

extension WeatherViewController: LocationDataManagerDelegate {
    
    func location(_ manager: LocationDataManager, didLoadCoordinate coordinate: CLLocationCoordinate2D) {
        dataManager.downloadData(with: coordinate)
    }
    
    func loaction(_ manager: LocationDataManager, didCompletePlacemark placemark: CLPlacemark?) {
        guard let placemark else {
            print("can't look up current address")
            return
        }
        
        dataManager.address = "\(placemark.locality ?? "") \(placemark.subLocality ?? "")"
    }
    
    func viewRequestLocationSettingAlert() {
        let requestLocationServiceAlert = UIAlertController(
            title: "위치 정보 이용",
            message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.",
            preferredStyle: .alert
        )
        let openSettingAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let exitAction = UIAlertAction(title: "종료", style: .destructive) { _ in
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        
        requestLocationServiceAlert.addAction(openSettingAction)
        requestLocationServiceAlert.addAction(exitAction)
        present(requestLocationServiceAlert, animated: true)
    }
}

// MARK: - WeatherDataManagerDelegate

extension WeatherViewController: WeatherDataManagerDelegate {
    func completedLoadData(_ manager: WeatherDataManager) {
        updateView()
    }
    
    private func updateView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Set refreshControl

extension WeatherViewController {
    private func setRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc
    private func handleRefreshControl() {
        collectionView.reloadData()
        DispatchQueue.main.async {
           self.collectionView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - Bind view

extension WeatherViewController {
    private func bind(on header: WeatherCollectionHeaderView) {
        header.addressLabel.text = dataManager.address
        if let today = dataManager.today {
            let temperature = today.main.temp.formatCelsius()
            let temperatureMin = today.main.tempMin.formatCelsius()
            let temperatureMax = today.main.tempMax.formatCelsius()
            let code = today.weather[0].icon
            
            header.currentTemperatureLabel.text = temperature
            header.maxAndMinTemperatureLabel.text = "최저 \(temperatureMin) 최고 \(temperatureMax)"
            bindImage(imageView: header.headerIconImageView, code: code)
        }
    }
    
    private func bind(on cell: WeatherCollectionViewCell, indexPath: IndexPath) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if let forecast = dataManager.forecast {
            let timeInterval = forecast.list[indexPath.row].dt
            let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
            let temperature = forecast.list[indexPath.row].main.temp.formatCelsius()
            let code = forecast.list[indexPath.row].weather[0].icon
            
            cell.dateLabel.text = dateFormatter.string(from: date as Date)
            cell.temperatureLabel.text = temperature
            bindImage(imageView: cell.cellIconImageView, code: code)
        }
    }
    
    private func bindImage(imageView: UIImageView, code: String) {
        if let image = ImageCacheManager.getCache(forKey: code) {
            imageView.image = image
        } else {
            guard let image = imageFileManager.getImage(forKey: code) else {
                print("fileManager에 해당 image 없음")
                return
            }
            ImageCacheManager.setCache(image: image, forKey: code)
            imageView.image = image
        }
    }
}
