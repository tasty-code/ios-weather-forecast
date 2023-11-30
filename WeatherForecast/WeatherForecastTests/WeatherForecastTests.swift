import XCTest
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {
    let coordinate = Coordinate(longitude: 127.3, latitude: 37.6)
    let apiKey = "API_KEY"
    
    func test_잘못된API_KEY_입력() throws {
        var errorMessage: String = ""
        WeatherNetworkService().getWeatherData(keyName: "API_KE", weatherType: .current, coordinate: coordinate) { (result: Result<CurrentWeather, NetworkError>) in
            switch result {
            case .success(_ ):
                return
            case .failure(let error):
                errorMessage = error.description
                XCTAssertEqual(errorMessage,"잘못된 Api Key의 이름입니다.")
                return
            }
        }
    }

    func test_올바른_Data_받아오기() throws {
        let city = "Gyeonggi-do"
        var name = ""
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")
        WeatherNetworkService().getWeatherData(keyName: "API_KEY", weatherType: .forecast, coordinate: coordinate) { (result: Result<ForecastWeather, NetworkError>) in
            switch result {
            case .success(let weatherInformation ):
                name = weatherInformation.city.name
                expectation.fulfill()
                return
            case .failure(_ ):
                return
            }
        }
        wait(for: [expectation], timeout: 4)
        XCTAssertEqual(city, name)
    }
}
