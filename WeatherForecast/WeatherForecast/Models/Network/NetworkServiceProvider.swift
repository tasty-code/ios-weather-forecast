import Foundation

class NetworkServiceProvider: NetworkServiceable {
    
    func fetch<T: Decodable>(url: URL, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            self.handlingDataResponse(data: data, response: response, error: error, completionHandler: completionHandler)
        }.resume()
    }
    
}
