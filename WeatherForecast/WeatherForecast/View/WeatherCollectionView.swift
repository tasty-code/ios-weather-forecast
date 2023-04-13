//
//  WeatherCollectionView.swift
//  WeatherForecast
//
//  Created by 신동오 on 2023/04/05.
//

import UIKit

class WeatherCollectionView: UICollectionView {
    
    // MARK: - Private property
    private var flowLayout: UICollectionViewFlowLayout = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        
        return layout
    }()
    
    // MARK: - Lifecycle
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
