import Foundation

final class NetworkManager<T: DataTransferable>: Networkable {
    func fetch(completion: @escaping (Result<DataTransferable, NetworkError>) -> Void) {
        var url : URL?
        do {
            url = try URL(string: "https://api.openweathermap.org/data/2.5/\(T.name)?lat=37.715122&lon=126.734086&appid=\(apiKey)")
        } catch {
            print(error)
        }
        
        guard let url = url else {
            return completion(.failure(.noExistedUrl))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noExistedData))
            }
            do {
                let weatherResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
