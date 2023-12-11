//
//  ForecastDataService.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/30/23.
//

import Foundation

final class ForecastDataService: DataDownloadable {
    private let decoder: JSONDecodable
    private weak var delegate: WeatherForecastDataServiceDelegate?
    
    init(dataServiceDelegate: WeatherForecastDataServiceDelegate) {
        self.decoder = JSONFormatter(decoder: JSONDecoder())
        self.delegate = dataServiceDelegate
    }
    
    func downloadData(serviceType: ServiceType) {
        guard let url = serviceType.makeURL() else { return }
        
        print(url)
        
        NetworkManager.downloadData(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                let model = self?.decoder.decodeJSON(ForecastModel.self, from: data)
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.delegate?.notifyForecastModelDidUpdate(dataService: self, model: model)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
