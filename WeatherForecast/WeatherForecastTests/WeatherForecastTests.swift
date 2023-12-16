import XCTest
import CoreLocation
@testable import WeatherForecast

final class WeatherForecastTests: XCTestCase {
    
    var url: URL!
    var data: Data!
    let jsonLoader = JsonLoader()
    
    override func setUpWithError() throws {
        
        let coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        url = WeatherURLConfigration(weatherType: .current, coordinate: coordinate).makeURL()
        data = jsonLoader.data(fileName: "MockWeather")
    }
    
    override func tearDownWithError() throws {
        url = nil
        data = nil
    }
    
    func test_fetchData_Data가_있고_statusCode가_200일때() {
        // given
        let mockURLSession = MockURLSession.make(url: url, data: data, statusCode: 200)
        let sut = NetworkServiceProvider(session: mockURLSession)
        
        // when
        var weather: CurrentWeather?
        sut.fetch(url: url) { (response: Result<CurrentWeather,NetworkError>) in
            if case let .success(weatherdata) = response {
                weather = weatherdata
            }
        }
        guard let weather = weather else { return }
        // then
        let expectation: CurrentWeather? = jsonLoader.load(type: weather , fileName: "MockWeather")
        XCTAssertEqual(weather.coordinate.latitude, expectation?.coordinate.latitude)
    }
    
    func test_fetchData_Data가_있고_statusCode가_404일때() {
        // given
        let mockURLSession = MockURLSession.make(url: url, data: data, statusCode: 404)
        let sut = NetworkServiceProvider(session: mockURLSession)
        
        // when
        var weather: (CurrentWeather)?
        sut.fetch(url: url) { (response: Result<CurrentWeather,NetworkError>) in
            if case let .success(weatherdata) = response {
                weather = weatherdata
            }
        }
        
        XCTAssertNil(weather)
    }
    
    func test_fetchData_Data가_잘못된type일때() {
        // given
        let mockURLSession = MockURLSession.make(url: url, data: data, statusCode: 404)
        let sut = NetworkServiceProvider(session: mockURLSession)
        
        // when
        var weather: (ForecastWeather)?
        sut.fetch(url: url) { (response: Result<ForecastWeather,NetworkError>) in
            if case let .success(weatherdata) = response {
                weather = weatherdata
            }
        }
        
        XCTAssertNil(weather?.city.name)
    }
    
    // MARK: - 실제로 통신하는 네트워크 테스트 코드
    
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
