//
//  CurrentWeatherViewModel.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/19.
//

import UIKit
import CoreData

final class CurrentWeatherViewModel {
        
    var currentWeather : WeatherData?
    var forecastWeatherData : ForecastWeatherData?
    var eventHandler : ((_ event : Event) -> Void)?
    
    
    func fetchCurrentWeather(latitude: String, longitude: String){
        APIManager.shared.getCurrentWeather(latitude: latitude, longitude: longitude) { response in
            self.eventHandler?(.loading)
            switch response {
            case .success(let weather):
                self.currentWeather = weather
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                self.eventHandler?(.error(error))
            }
        }
    }
}

