import Foundation

final class Networker<T: Decodable> {
    private var networkManager: NetworkManager<T>?

    func fetchWeatherData() {
        let url = makeURL()
        
        networkManager = NetworkManager<T>(url: url)
        
        guard let networkManager = networkManager else {
            return
        }
        
        networkManager.fetch { result in
            switch result {
            case .success(let weatherResponse):
                print(weatherResponse)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension Networker: KeyAuthenticatable {
    private func makeURL() -> URL? {
        guard let APIKey = APIKey else {
            return nil
        }
        
        guard let weatherType = T.weatherType else {
            return nil
        }
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/\(weatherType)?lat=37.715122&lon=126.734086&appid=\(APIKey)")
        return url
    }
}
