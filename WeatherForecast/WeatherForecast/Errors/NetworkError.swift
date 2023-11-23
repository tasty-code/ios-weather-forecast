import Foundation

enum NetworkError: Error {
    case urlError
    case unknownError
    case handleServerError(response: URLResponse?)
    case dataUnwrappingError
    case decodingError
}
