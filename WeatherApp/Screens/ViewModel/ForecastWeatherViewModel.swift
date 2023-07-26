//
//  ForecastWeatherViewModel.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/20.
//

import Foundation

final class ForecastWeatherViewModel {
    
    var forecastWeatherData : ForecastWeatherData?
    var eventHandler : ((_ event : Event) -> Void)?
    
    func fetchForecastWeatherData(latitude: String, longitude: String){
        APIManager.shared.getForecastWeather(latitude: latitude, longitude: longitude) { response in
            self.eventHandler?(.loading)
            switch response {
            case .success(let weather):
                self.forecastWeatherData = weather
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                self.eventHandler?(.error(error))
            }
        }
    }
}
