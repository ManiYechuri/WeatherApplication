//
//  APIManager.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/19.
//

import UIKit

typealias Handler = (Result<WeatherData,DataError>) -> Void
typealias forecastWeatherHandler = (Result<ForecastWeatherData, DataError>) -> Void

class APIManager {
    
    static let shared = APIManager()
    init(){}
    
    func getCurrentWeather(latitude : String,longitude : String,completion : @escaping Handler){
        guard let url = URL(string: Constant.API.currentWeatherAPI + "lat=\(latitude)&lon=\(longitude)&appid=\(Constant.APPID.appId)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else {
                return
            }
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                return
            }
            do {
                let currentWeather = try JSONDecoder().decode(WeatherData.self, from: data)
                DatabaseHelper.shared.saveCurrentWeather(currentWeather: currentWeather)
                completion(.success(currentWeather))
            }catch {
                completion(.failure(.network(error)))
            }
        }.resume()
    }
    
    func getForecastWeather(latitude : String,longitude : String,completion : @escaping forecastWeatherHandler){
        guard let url = URL(string: Constant.API.forecastWeatherAPI + "lat=\(latitude)&lon=\(longitude)&appid=\(Constant.APPID.appId)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else {
                return
            }
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                return
            }
            do {
                let forecastWeather = try JSONDecoder().decode(ForecastWeatherData.self, from: data)
                DatabaseHelper.shared.saveForecastWeatherData(forecase: forecastWeather)
                completion(.success(forecastWeather))
            }catch {
                completion(.failure(.network(error)))
            }
        }.resume()
    }
}
