import Foundation

final class NetworkManager<T: Decodable>: Networkable {
    private let url: URL?
    private let session: URLSession
    
    init(url: URL?, session: URLSession = URLSession.shared) {
        self.url = url
        self.session = session
    }
    
    func fetch(completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = url else {
            return completion(.failure(.urlError(url)))
        }
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(.unknownError(error)))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.serverError(response)))
            }
            guard let data = data else {
                return completion(.failure(.dataUnwrappingError(data)))
            }

            do {
                let weatherResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
