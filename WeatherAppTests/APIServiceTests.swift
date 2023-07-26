//
//  APIServiceTests.swift
//  DVT_WeatherAppTests
//
//  Created by Mani Yechuri on 2023/07/26.
//

import XCTest
@testable import DVT_WeatherApp

final class APIServiceTests: XCTestCase {
    
    var apiService : APIManager?

    override func setUpWithError() throws {
        try super.setUpWithError()
        apiService = APIManager()
    }

    override func tearDownWithError() throws {
        apiService = nil
        try super.tearDownWithError()
    }

    func testCurrentWeatherAPI() throws {
        let service = apiService!
        
        let expect = XCTestExpectation(description: "callback")
        
        service.getCurrentWeather(latitude: "37.785834", longitude: "-122.406417") { response in
            expect.fulfill()
            switch response {
            case .success(let weather):
                XCTAssertNotNil(weather)
            case .failure(let error):
                XCTAssertTrue(true)
            }
        }
        wait(for: [expect])
    }
    
    func testForecastWeatherAPI(){
        let service = apiService!
        
        let expect = XCTestExpectation(description: "callback")
        
        service.getForecastWeather(latitude: "37.785834", longitude: "-122.406417") { response in
            expect.fulfill()
            switch response {
            case .success(let weather):
                XCTAssertNotNil(weather)
            case .failure(let error):
                XCTAssertTrue(true)
            }
        }
        wait(for: [expect])
    }

    func testPerformanceExample() throws {
        self.measure {
        }
    }

}
