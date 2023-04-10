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
//        layout.sectionInset = UIEdgeInsets(top: 200, left: 200, bottom: 200, right: 200) // 각 섹션의 마진
        
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
