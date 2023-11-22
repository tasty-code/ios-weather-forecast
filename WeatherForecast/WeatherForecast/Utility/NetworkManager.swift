//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 김수경 on 2023/11/22.
//

import Foundation

final class NetworkManager {
    private let urlFormatter: any URLFormattable
    private let session: URLSession
    
    init(urlFormatter: any URLFormattable, session: URLSession = URLSession.shared) {
        self.urlFormatter = urlFormatter
        self.session = session
    }

}
