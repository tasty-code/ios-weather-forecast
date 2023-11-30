//
//  ForecastDataService.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/30/23.
//

import Foundation

final class ForecastDataService: DataDownloadable {
    private let decoder: JSONDecodable
    private weak var delegate: DataServiceDelegate?
    
    init(dataServiceDelegate: DataServiceDelegate) {
        self.decoder = JSONFormatter(decoder: JSONDecoder())
        self.delegate = dataServiceDelegate
    }
    
    func downloadData(serviceType: ServiceType) {
        guard let url = serviceType.makeURL() else { return }
        
        NetworkManager.downloadData(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                let model = self?.decoder.decodeJSON(serviceType.decodingType, from: data)
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    guard let forecastModel = model as? ForecastModel else { return }
                    self.delegate?.notifyForecastModelDidUpdate(dataService: self, model: forecastModel)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
