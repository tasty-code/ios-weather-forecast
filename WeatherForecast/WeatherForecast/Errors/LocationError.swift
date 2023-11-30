import Foundation

enum LocationError: Error {
    case cooridnateError
    case placemarkError
    case unknownError(_ error: Error)
}
