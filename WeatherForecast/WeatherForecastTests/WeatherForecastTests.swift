//
//  WeatherForecastTests - WeatherForecastTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {
    var sutCurrent: NetworkService<CurrentWeatherComponents>!
    var sutForecast: NetworkService<ForecastWeatherComponents>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sutCurrent = WeatherParser()
        sutForecast = WeatherParser()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sutCurrent = nil
        sutForecast = nil
    }

    func test_URL이_Query형식에_맞게_생성되는가() {
        // given
        let yongsanCoordinate = CurrentCoordinate(latitude: 37.53, longitude: 126.96)
        let apiKey = Bundle.main.apiKey

        // when
        let yonsanCurrentURL = try? WeatherAPIEndpoint.makeDataURL(at: yongsanCoordinate, weatherRange: CurrentWeatherComponents.weatherRange)
        let yonsanForecastURL = try? WeatherAPIEndpoint.makeDataURL(at: yongsanCoordinate, weatherRange: ForecastWeatherComponents.weatherRange)
        let resultCurrentURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=37.53&lon=126.96&units=metric&lang=kr&appid=\(apiKey)")
        let resultForecastURL = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=37.53&lon=126.96&units=metric&lang=kr&appid=\(apiKey)")

        // then
        XCTAssertEqual(yonsanCurrentURL, resultCurrentURL)
        XCTAssertEqual(yonsanForecastURL, resultForecastURL)
    }

    func test_요청한_위경도와_호출된_데이터의_지역이_일치하는가() async {
        // given
        let yongsanCoordinate = CurrentCoordinate(latitude: 37.53, longitude: 126.96)

        // when
        let cityOfRequestedCurrentWeather = try? await type(of: sutCurrent).parseWeatherData(at: yongsanCoordinate).name
        let cityOfRequestedForecastWeather = try? await type(of: sutForecast).parseWeatherData(at: yongsanCoordinate).city.name
        let resultCityName = "Yongsan"

        // then
        XCTAssertEqual(cityOfRequestedCurrentWeather, resultCityName)
        XCTAssertEqual(cityOfRequestedForecastWeather, resultCityName)
    }
}
