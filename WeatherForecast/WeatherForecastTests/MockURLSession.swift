import Foundation
@testable import WeatherForecast

final class MockURLSession: URLSessionProtocol {
    
    typealias Response = (data: Data?, urlResponse: URLResponse?, error: Error?)
    
    let response: Response
    
    init(response: Response) {
        self.response = response
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return MockURLSessionDataTesk(resumeHandler: { completionHandler(self.response.data,
                          self.response.urlResponse,
                          self.response.error)
        })
    }
    
    static func make(url: URL, data: Data?, statusCode: Int) -> MockURLSession {
           let mockURLSession: MockURLSession = {
               let urlResponse = HTTPURLResponse(url: url,
                                              statusCode: statusCode,
                                              httpVersion: nil,
                                              headerFields: nil)
               let mockResponse: MockURLSession.Response = (data: data,
                                                            urlResponse: urlResponse,
                                                            error: nil)
               let mockUrlSession = MockURLSession(response: mockResponse)
               return mockUrlSession
           }()
           return mockURLSession
       }
    
}


final class MockURLSessionDataTesk: URLSessionDataTaskProtocol {
    private let resumeHandler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    
    func resume() {
         resumeHandler()
    }
}
