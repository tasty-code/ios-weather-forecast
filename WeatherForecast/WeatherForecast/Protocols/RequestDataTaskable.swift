import Foundation
protocol RequestDataTaskable {
    func resume()
}

extension URLSessionDataTask: RequestDataTaskable { }
