//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Mani Yechuri on 2023/07/18.
//

import XCTest
@testable import DVT_WeatherApp

final class WeatherAppTests: XCTestCase {
    
    var viewModel : CurrentWeatherViewModel?
    var locationManager : MyLocationManager?

    override func setUpWithError() throws {
        locationManager = MyLocationManager()
        viewModel = CurrentWeatherViewModel()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        locationManager = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        
    }
    
    func testGetCurrentWeatherDataNotNil(){
        MyLocationManager.shared.getUserLocation { location in
            self.viewModel?.fetchCurrentWeather(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)")
        }
        let expect = XCTestExpectation(description: "apiCallback")
        
        self.viewModel?.eventHandler = { event in
            XCTAssertNotNil(event)
            
        }
        wait(for: [expect])
    }
    
    func testGetCurrentWeatherDataIsNil(){
        MyLocationManager.shared.getUserLocation { location in
            self.viewModel?.fetchCurrentWeather(latitude: "", longitude: "")
        }
        let expect = XCTestExpectation(description: "apiCallback")
        
        self.viewModel?.eventHandler = { event in
            XCTAssertNil(event)
            
        }
        wait(for: [expect])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
