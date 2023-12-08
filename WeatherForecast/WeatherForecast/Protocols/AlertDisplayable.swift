//
//  AlertDisplayable.swift
//  WeatherForecast
//
//  Created by 김진웅 on 12/8/23.
//

import UIKit

protocol AlertDisplayable {
    func displayAlert(title: String, message: String?, handler: (() -> Void)?)
}

extension AlertDisplayable where Self: UIViewController {
    func displayAlert(title: String, message: String? = nil, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let handler = handler {
                handler()
            }
        }
                                     
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
