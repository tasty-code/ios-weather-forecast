import Foundation

final class NetworkServiceProvider: NetworkServiceable {
    
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func fetch<T: Decodable>(url: URL, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            self.handlingDataResponse(data: data, response: response, error: error, completionHandler: completionHandler)
        }.resume()
    }
    
}
