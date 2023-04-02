//
//  ForecastViewModel.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

final class ForecastViewModel {
    
    private let service = ForecastService()
    
    func requestFetchData() {
        service.fetchForecast {
            
        }
    }
    
    
//    // MARK: - Inputs
//
//    struct Input {
//
//    }
//
//    // MARK: - Outputs
//
//    struct Output {
//
//    }
//
//    // MARK: - init
//
//    init(useCase: ForecastUseCase) {
//        self.useCase = useCase
//    }
}

extension ForecastViewModel {
//    func transform(from input: Input) -> Output {
//        let output = Output()
//        self.bindOutput(output: output)
//
//        return output
//    }
//
//    private func bindOutput(output: Output) {
//
//    }
}
